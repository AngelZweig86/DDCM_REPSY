!******************************************************************************
!******************************************************************************
SUBROUTINE wrapper_normal_pdf(rslt, x, mean, sd)

    !/* external libraries      */

    USE resfort_library

    !/* setup                   */

    IMPLICIT NONE

    !/* external objects        */

    DOUBLE PRECISION, INTENT(OUT)      :: rslt

    DOUBLE PRECISION, INTENT(IN)       :: x
    DOUBLE PRECISION, INTENT(IN)       :: mean
    DOUBLE PRECISION, INTENT(IN)       :: sd

!------------------------------------------------------------------------------
! Algorithm
!------------------------------------------------------------------------------

    ! Call function of interest
    rslt = normal_pdf(x, mean, sd)

END SUBROUTINE
!******************************************************************************
!******************************************************************************
SUBROUTINE wrapper_pinv(rslt, A, m)

    !/* external libraries      */

    USE resfort_library

    !/* setup                   */

    IMPLICIT NONE

    !/* external objects        */

    DOUBLE PRECISION, INTENT(OUT)   :: rslt(m, m)

    DOUBLE PRECISION, INTENT(IN)    :: A(m, m)
    
    INTEGER, INTENT(IN)             :: m

!------------------------------------------------------------------------------
! Algorithm
!------------------------------------------------------------------------------

    ! Call function of interest
    rslt = pinv(A, m)
    
END SUBROUTINE
!******************************************************************************
!******************************************************************************
SUBROUTINE wrapper_svd(U, S, VT, A, m)

    !/* external libraries      */

    USE resfort_library

    !/* setup                   */

    IMPLICIT NONE

    !/* external objects        */

    DOUBLE PRECISION, INTENT(OUT)   :: S(m) 
    DOUBLE PRECISION, INTENT(OUT)   :: U(m, m)
    DOUBLE PRECISION, INTENT(OUT)   :: VT(m, m)

    DOUBLE PRECISION, INTENT(IN)    :: A(m, m)
    
    INTEGER, INTENT(IN)             :: m

!------------------------------------------------------------------------------
! Algorithm
!------------------------------------------------------------------------------
    
    ! Call function of interest
    CALL svd(U, S, VT, A, m)

END SUBROUTINE
!******************************************************************************
!******************************************************************************
SUBROUTINE wrapper_get_future_value(emax_simulated, num_periods_int, num_draws_emax_int, period, k, draws_emax, payoffs_systematic, edu_max_int, edu_start_int, periods_emax_int, states_all, mapping_state_idx_int, delta_int, shocks_cholesky)

    !/* external libraries      */

    USE resfort_library

    !/* setup                   */

    IMPLICIT NONE

    !/* external objects        */

    DOUBLE PRECISION, INTENT(OUT)   :: emax_simulated

    DOUBLE PRECISION, INTENT(IN)    :: payoffs_systematic(:)
    DOUBLE PRECISION, INTENT(IN)    :: shocks_cholesky(4, 4)
    DOUBLE PRECISION, INTENT(IN)    :: periods_emax_int(:,:)
    DOUBLE PRECISION, INTENT(IN)    :: draws_emax(:,:)
    DOUBLE PRECISION, INTENT(IN)    :: delta_int

    INTEGER, INTENT(IN)             :: mapping_state_idx_int(:,:,:,:,:)
    INTEGER, INTENT(IN)             :: states_all(:,:,:)
    INTEGER, INTENT(IN)             :: num_draws_emax_int
    INTEGER, INTENT(IN)             :: edu_max_int
    INTEGER, INTENT(IN)             :: num_periods_int
    INTEGER, INTENT(IN)             :: edu_start_int
    INTEGER, INTENT(IN)             :: period
    INTEGER, INTENT(IN)             :: k

!------------------------------------------------------------------------------
! Algorithm
!------------------------------------------------------------------------------
    
    ! Assign global RESFORT variables
    max_states_period = SIZE(states_all, 2)
    min_idx = SIZE(mapping_state_idx_int, 4)

    !# Transfer global RESFORT variables
    num_draws_emax = num_draws_emax_int
    num_periods = num_periods_int
    edu_start = edu_start_int
    edu_max = edu_max_int
    delta = delta_int

    ! Call function of interest
    CALL get_future_value(emax_simulated, draws_emax, period, k, payoffs_systematic, mapping_state_idx_int, states_all, periods_emax_int, shocks_cholesky)

END SUBROUTINE
!******************************************************************************
!******************************************************************************
SUBROUTINE wrapper_standard_normal(draw, dim)

    !/* external libraries      */

    USE resfort_library

    !/* setup                   */

    IMPLICIT NONE

    !/* external objects        */

    INTEGER, INTENT(IN)             :: dim
    
    DOUBLE PRECISION, INTENT(OUT)   :: draw(dim)

!------------------------------------------------------------------------------
! Algorithm
!------------------------------------------------------------------------------

    ! Call function of interest
    CALL standard_normal(draw)

END SUBROUTINE 
!******************************************************************************
!******************************************************************************
SUBROUTINE wrapper_determinant(det, A)

    !/* external libraries      */

    USE resfort_library

    !/* setup                   */

    IMPLICIT NONE

    !/* external objects        */

    DOUBLE PRECISION, INTENT(OUT)   :: det

    DOUBLE PRECISION, INTENT(IN)    :: A(:, :)

!------------------------------------------------------------------------------
! Algorithm
!------------------------------------------------------------------------------

    ! Call function of interest
    det = determinant(A)

END SUBROUTINE
!******************************************************************************
!******************************************************************************
SUBROUTINE wrapper_inverse(inv, A, n)

    !/* external libraries      */

    USE resfort_library

    !/* setup                   */

    IMPLICIT NONE

    !/* external objects        */

    DOUBLE PRECISION, INTENT(OUT)   :: inv(n, n)

    DOUBLE PRECISION, INTENT(IN)    :: A(:, :)

    INTEGER, INTENT(IN)             :: n

!------------------------------------------------------------------------------
! Algorithm
!------------------------------------------------------------------------------

    ! Call function of interest
    inv = inverse(A, n)

END SUBROUTINE
!******************************************************************************
!******************************************************************************
SUBROUTINE wrapper_trace(rslt, A)

    !/* external libraries      */

    USE resfort_library

    !/* setup                   */

    IMPLICIT NONE

    !/* external objects        */

    DOUBLE PRECISION, INTENT(OUT) :: rslt

    DOUBLE PRECISION, INTENT(IN)  :: A(:,:)

!------------------------------------------------------------------------------
! Algorithm
!------------------------------------------------------------------------------

    ! Call function of interest
    rslt = trace_fun(A)

END SUBROUTINE
!******************************************************************************
!******************************************************************************
SUBROUTINE wrapper_clip_value(clipped_value, value, lower_bound, upper_bound, num_values)

    !/* external libraries      */

    USE resfort_library

    !/* setup                   */

    IMPLICIT NONE

    !/* external objects        */

    DOUBLE PRECISION, INTENT(OUT)       :: clipped_value(num_values)

    DOUBLE PRECISION, INTENT(IN)        :: value(:)
    DOUBLE PRECISION, INTENT(IN)        :: lower_bound
    DOUBLE PRECISION, INTENT(IN)        :: upper_bound 

    INTEGER, INTENT(IN)                 :: num_values

!------------------------------------------------------------------------------
! Algorithm
!------------------------------------------------------------------------------

    ! Call function of interest
    clipped_value = clip_value(value, lower_bound, upper_bound)


END SUBROUTINE
!******************************************************************************
!******************************************************************************
SUBROUTINE wrapper_get_pred_info(r_squared, bse, Y, P, X, num_states, num_covars)

    !/* external libraries      */

    USE resfort_library

    !/* setup                   */

    IMPLICIT NONE

    !/* external objects        */

    DOUBLE PRECISION, INTENT(OUT)   :: bse(num_covars)
    DOUBLE PRECISION, INTENT(OUT)   :: r_squared
    
    DOUBLE PRECISION, INTENT(IN)    :: X(num_states, num_covars)
    DOUBLE PRECISION, INTENT(IN)    :: Y(num_states)
    DOUBLE PRECISION, INTENT(IN)    :: P(num_states)
    
    INTEGER, INTENT(IN)             :: num_states
    INTEGER, INTENT(IN)             :: num_covars

!------------------------------------------------------------------------------
! Algorithm
!------------------------------------------------------------------------------

    ! Call function of interest
    CALL get_pred_info(r_squared, bse, Y, P, X, num_states, num_covars)

END SUBROUTINE
!******************************************************************************
!******************************************************************************
SUBROUTINE wrapper_point_predictions(Y, X, coeffs, num_states)

    !/* external libraries      */

    USE resfort_library

    !/* setup                   */

    IMPLICIT NONE

    !/* external objects        */

    DOUBLE PRECISION, INTENT(OUT)       :: Y(num_states)

    DOUBLE PRECISION, INTENT(IN)        :: coeffs(:)
    DOUBLE PRECISION, INTENT(IN)        :: X(:,:)
    
    INTEGER, INTENT(IN)                 :: num_states

!------------------------------------------------------------------------------
! Algorithm
!------------------------------------------------------------------------------

    ! Call function of interest
    CALL point_predictions(Y, X, coeffs, num_states)

END SUBROUTINE
!******************************************************************************
!******************************************************************************
SUBROUTINE wrapper_get_predictions(predictions, endogenous, exogenous, maxe, is_simulated, num_points_interp_int, num_states)

    !/* external libraries      */

    USE resfort_library

    !/* setup                   */

    IMPLICIT NONE

    !/* external objects        */

    DOUBLE PRECISION, INTENT(OUT)               :: predictions(num_states)

    DOUBLE PRECISION, INTENT(IN)                :: exogenous(:, :)
    DOUBLE PRECISION, INTENT(IN)                :: endogenous(:)
    DOUBLE PRECISION, INTENT(IN)                :: maxe(:)

    INTEGER, INTENT(IN)                         :: num_states
    INTEGER, INTENT(IN)                         :: num_points_interp_int

    LOGICAL, INTENT(IN)                         :: is_simulated(:)

!------------------------------------------------------------------------------
! Algorithm

!------------------------------------------------------------------------------
    
    ! Transfer global RESFORT variables
    num_points_interp = num_points_interp_int

    ! Call function of interest
    CALL get_predictions(predictions, endogenous, exogenous, maxe, is_simulated, num_states)

END SUBROUTINE
!******************************************************************************
!******************************************************************************
SUBROUTINE wrapper_random_choice(sample, candidates, num_candidates, num_points)

    !/* external libraries      */

    USE resfort_library

    !/* setup                   */

    IMPLICIT NONE

    !/* external objects        */

    INTEGER, INTENT(OUT)            :: sample(num_points)

    INTEGER, INTENT(IN)             :: candidates(:)
    INTEGER, INTENT(IN)             :: num_candidates
    INTEGER, INTENT(IN)             :: num_points

!------------------------------------------------------------------------------
! Algorithm
!------------------------------------------------------------------------------

    ! Call function of interest
     CALL random_choice(sample, candidates, num_candidates, num_points)

END SUBROUTINE
!******************************************************************************
!******************************************************************************
SUBROUTINE wrapper_get_coefficients(coeffs, Y, X, num_covars, num_states)

    !/* external libraries      */

    USE resfort_library

    !/* setup                   */

    IMPLICIT NONE

    !/* external objects        */

    DOUBLE PRECISION, INTENT(OUT)   :: coeffs(num_covars)

    DOUBLE PRECISION, INTENT(IN)    :: X(:,:)
    DOUBLE PRECISION, INTENT(IN)    :: Y(:)
    
    INTEGER, INTENT(IN)             :: num_covars
    INTEGER, INTENT(IN)             :: num_states

!------------------------------------------------------------------------------
! Algorithm
!------------------------------------------------------------------------------

    ! Call function of interest
    CALL get_coefficients(coeffs, Y, X, num_covars, num_states)

END SUBROUTINE
!******************************************************************************
!******************************************************************************
SUBROUTINE wrapper_get_endogenous_variable(exogenous_variable, period, num_periods_int, num_states, delta_int, periods_payoffs_systematic_int, edu_max_int, edu_start_int, mapping_state_idx_int, periods_emax_int, states_all, is_simulated, num_draws_emax_int, maxe, draws_emax, shocks_cholesky)

    !/* external libraries      */

    USE resfort_library

    !/* setup                   */

    IMPLICIT NONE

    !/* external objects        */

    DOUBLE PRECISION, INTENT(OUT)       :: exogenous_variable(num_states)

    DOUBLE PRECISION, INTENT(IN)        :: periods_payoffs_systematic_int(:, :, :)
    DOUBLE PRECISION, INTENT(IN)        :: shocks_cholesky(4, 4)
    DOUBLE PRECISION, INTENT(IN)        :: periods_emax_int(:, :)
    DOUBLE PRECISION, INTENT(IN)        :: draws_emax(:, :)
    DOUBLE PRECISION, INTENT(IN)        :: maxe(:)
    DOUBLE PRECISION, INTENT(IN)        :: delta_int

    INTEGER, INTENT(IN)                 :: mapping_state_idx_int(:, :, :, :, :)    
    INTEGER, INTENT(IN)                 :: states_all(:, :, :)    
    INTEGER, INTENT(IN)                 :: num_draws_emax_int
    INTEGER, INTENT(IN)                 :: edu_max_int    
    INTEGER, INTENT(IN)                 :: num_periods_int
    INTEGER, INTENT(IN)                 :: num_states
    INTEGER, INTENT(IN)                 :: edu_start_int
    INTEGER, INTENT(IN)                 :: period


    LOGICAL, INTENT(IN)                 :: is_simulated(:)

!------------------------------------------------------------------------------
! Algorithm
!------------------------------------------------------------------------------
    
    ! Transfer global RESFORT variables
    num_draws_emax = num_draws_emax_int
    num_periods = num_periods_int
    edu_start = edu_start_int
    edu_max = edu_max_int
    delta = delta_int

    ! Call function of interest
    CALL get_endogenous_variable(exogenous_variable, period, num_states, periods_payoffs_systematic_int, mapping_state_idx_int, periods_emax_int, states_all, is_simulated, maxe, draws_emax, shocks_cholesky)

END SUBROUTINE
!******************************************************************************
!******************************************************************************
SUBROUTINE wrapper_get_exogenous_variables(independent_variables, maxe, period, num_periods_int, num_states, delta_int, periods_payoffs_systematic_int, shifts, edu_max_int, edu_start_int, mapping_state_idx_int, periods_emax_int, states_all)

    !/* external libraries      */

    USE resfort_library

    !/* setup                   */

    IMPLICIT NONE

    !/* external objects        */

    DOUBLE PRECISION, INTENT(OUT)        :: independent_variables(num_states, 9)
    DOUBLE PRECISION, INTENT(OUT)        :: maxe(num_states)


    DOUBLE PRECISION, INTENT(IN)        :: periods_payoffs_systematic_int(:, :, :)
    DOUBLE PRECISION, INTENT(IN)        :: periods_emax_int(:, :)
    DOUBLE PRECISION, INTENT(IN)        :: shifts(:)
    DOUBLE PRECISION, INTENT(IN)        :: delta_int

    INTEGER, INTENT(IN)                 :: mapping_state_idx_int(:, :, :, :, :)    
    INTEGER, INTENT(IN)                 :: states_all(:, :, :)    
    INTEGER, INTENT(IN)                 :: edu_max_int
    INTEGER, INTENT(IN)                 :: num_periods_int
    INTEGER, INTENT(IN)                 :: num_states
    INTEGER, INTENT(IN)                 :: edu_start_int
    INTEGER, INTENT(IN)                 :: period

!------------------------------------------------------------------------------
! Algorithm
!------------------------------------------------------------------------------

    !# Assign global RESFORT variables
    max_states_period = SIZE(states_all, 2)
    min_idx = SIZE(mapping_state_idx_int, 4)

    !# Transfer global RESFORT variables
    num_periods = num_periods_int
    edu_start = edu_start_int
    edu_max = edu_max_int
    delta = delta_int

    ! Call function of interest
    CALL get_exogenous_variables(independent_variables, maxe,  period, num_states, periods_payoffs_systematic_int, shifts, mapping_state_idx_int, periods_emax_int, states_all)
            
END SUBROUTINE
!******************************************************************************
!******************************************************************************
SUBROUTINE wrapper_get_simulated_indicator(is_simulated, num_points, num_states, period, is_debug_int, num_periods_int)

    !/* external libraries      */

    USE resfort_library

    !/* setup                   */

    IMPLICIT NONE

    !/* external objects        */

    LOGICAL, INTENT(OUT)            :: is_simulated(num_states)

    INTEGER, INTENT(IN)             :: num_periods_int
    INTEGER, INTENT(IN)             :: num_states
    INTEGER, INTENT(IN)             :: num_points
    INTEGER, INTENT(IN)             :: period

    LOGICAL, INTENT(IN)             :: is_debug_int

!------------------------------------------------------------------------------
! Algorithm
!------------------------------------------------------------------------------

    !# Transfer global RESFORT variables
    num_periods = num_periods_int
    is_debug = is_debug_int

    ! Call function of interest
    is_simulated = get_simulated_indicator(num_points, num_states, period)

END SUBROUTINE
!******************************************************************************
!******************************************************************************
