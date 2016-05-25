# project library
from respy.python.evaluate.evaluate_python import pyth_evaluate
from respy.fortran.f2py_library import f2py_evaluate
from respy.fortran.fortran import fort_evaluate

from respy.python.evaluate.evaluate_auxiliary import check_input
from respy.python.evaluate.evaluate_auxiliary import check_output

from respy.python.shared.shared_auxiliary import dist_class_attributes
from respy.python.shared.shared_auxiliary import dist_model_paras
from respy.python.shared.shared_auxiliary import create_draws

from respy.process import process


def evaluate(respy_obj):
    """ Evaluate the criterion function.
    """
    # Read in estimation dataset. It only reads in the number of agents
    # requested for the estimation.
    data_frame = process(respy_obj)

    # Antibugging
    assert check_input(respy_obj, data_frame)

    # Distribute class attributes
    model_paras, num_periods, num_agents_est, edu_start, is_debug, \
        edu_max, delta, version, num_draws_prob, seed_prob, num_draws_emax, \
        seed_emax, is_interpolated, num_points, is_myopic, min_idx, tau, \
        is_parallel, num_procs = \
            dist_class_attributes(respy_obj,
                'model_paras', 'num_periods', 'num_agents_est', 'edu_start',
                'is_debug', 'edu_max', 'delta', 'version', 'num_draws_prob',
                'seed_prob', 'num_draws_emax', 'seed_emax', 'is_interpolated',
                'num_points', 'is_myopic', 'min_idx', 'tau', 'is_parallel',
                'num_procs')

    # Distribute model parameters
    coeffs_a, coeffs_b, coeffs_edu, coeffs_home, shocks_cholesky = \
        dist_model_paras(model_paras, is_debug)

    # Draw standard normal deviates for choice probabilities and expected
    # future values.
    periods_draws_prob = create_draws(num_periods, num_draws_prob, seed_prob,
        is_debug)

    periods_draws_emax = create_draws(num_periods, num_draws_emax, seed_emax,
        is_debug)

    # Transform dataset for interface
    data_array = data_frame.as_matrix()

    base_args = (coeffs_a, coeffs_b, coeffs_edu, coeffs_home, shocks_cholesky,
        is_interpolated, num_draws_emax, num_periods, num_points, is_myopic,
        edu_start, is_debug, edu_max, min_idx, delta, data_array,
        num_agents_est, num_draws_prob, tau)

    # Select appropriate interface
    if version == 'FORTRAN':
        args = base_args + (seed_emax, seed_prob, is_parallel, num_procs)
        crit_val = fort_evaluate(*args)
    elif version == 'PYTHON':
        args = base_args + (periods_draws_emax, periods_draws_prob)
        crit_val = pyth_evaluate(*args)
    elif version == 'F2PY':
        args = base_args + (periods_draws_emax, periods_draws_prob)
        crit_val = f2py_evaluate(*args)
    else:
        raise NotImplementedError

    # Checks
    assert check_output(crit_val)

    # Finishing
    return crit_val
