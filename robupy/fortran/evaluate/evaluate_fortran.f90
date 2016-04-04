!*******************************************************************************
!*******************************************************************************
MODULE evaluate_fortran

	!/*	external modules	*/

    USE evaluate_auxiliary

    USE shared_auxiliary

    USE shared_constants

	!/*	setup	*/

	IMPLICIT NONE

    PUBLIC

 CONTAINS
!*******************************************************************************
!*******************************************************************************
SUBROUTINE fort_evaluate(rslt, periods_payoffs_systematic, mapping_state_idx, &
                periods_emax, states_all, shocks_cov, is_deterministic, &
                num_periods, edu_start, edu_max, delta, data_array, &
                num_agents, num_draws_prob, periods_draws_prob)

    !/* external objects        */

    REAL(our_dble), INTENT(OUT)     :: rslt


    INTEGER(our_int), INTENT(IN)    :: mapping_state_idx(:, :, :, :, :)
    INTEGER(our_int), INTENT(IN)    :: states_all(:, :, :)
    INTEGER(our_int), INTENT(IN)    :: num_draws_prob
    INTEGER(our_int), INTENT(IN)    :: num_periods
    INTEGER(our_int), INTENT(IN)    :: num_agents
    INTEGER(our_int), INTENT(IN)    :: edu_start
    INTEGER(our_int), INTENT(IN)    :: edu_max

    REAL(our_dble), INTENT(IN)      :: periods_draws_prob(:, :, :)
    REAL(our_dble), INTENT(IN)      :: data_array(:, :)
    REAL(our_dble), INTENT(IN)      :: shocks_cov(:, :)
    REAL(our_dble), INTENT(IN)      :: delta

    !/* internal objects        */

    REAL(our_dble), ALLOCATABLE     :: crit_val(:)

    REAL(our_dble), INTENT(IN)      :: periods_payoffs_systematic(:, :, :)
    REAL(our_dble), INTENT(IN)      :: periods_emax(:, :)

    INTEGER(our_int)                :: edu_lagged
    INTEGER(our_int)                :: counts(4)
    INTEGER(our_int)                :: choice
    INTEGER(our_int)                :: period
    INTEGER(our_int)                :: exp_a
    INTEGER(our_int)                :: exp_b
    INTEGER(our_int)                :: idx
    INTEGER(our_int)                :: edu
    INTEGER(our_int)                :: i
    INTEGER(our_int)                :: s
    INTEGER(our_int)                :: k
    INTEGER(our_int)                :: j

    REAL(our_dble)                  :: conditional_draws(num_draws_prob, 4)
    REAL(our_dble)                  :: draws_prob_raw(num_draws_prob, 4)
    REAL(our_dble)                  :: choice_probabilities(4)
    REAL(our_dble)                  :: payoffs_systematic(4)
    REAL(our_dble)                  :: shocks_cholesky(4, 4)
    REAL(our_dble)                  :: crit_val_contrib
    REAL(our_dble)                  :: total_payoffs(4)
    REAL(our_dble)                  :: draws(4), smoot_payoff(4), maxim_payoff(4)
    REAL(our_dble)                  :: dist, draws_cond(4), prob_choice
    REAL(our_dble)                  :: tau, prob_obs, draws_stan(4), prob_wage

    LOGICAL                         :: is_deterministic
    LOGICAL                         :: is_working

!-------------------------------------------------------------------------------
! Algorithm
!-------------------------------------------------------------------------------

    tau = 500.00

    ! Construct Cholesky decomposition
    IF (is_deterministic) THEN
        shocks_cholesky = zero_dble
    ELSE
        CALL cholesky(shocks_cholesky, shocks_cov)
    END IF

    ! Initialize container for likelihood contributions
    ALLOCATE(crit_val(num_agents * num_periods)); crit_val = zero_dble

    j = 1

    DO i = 0, num_agents - 1

        DO period = 0, num_periods -1

            ! Extract observable components of state space as well as agent
            ! decision.
            exp_a = INT(data_array(j, 5))
            exp_b = INT(data_array(j, 6))
            edu = INT(data_array(j, 7))
            edu_lagged = INT(data_array(j, 8))

            choice = INT(data_array(j, 3))
            is_working = (choice == 1) .OR. (choice == 2)

            ! Transform total years of education to additional years of
            ! education and create an index from the choice.
            edu = edu - edu_start

            ! This is only done for alignment
            idx = choice

            ! Get state indicator to obtain the systematic component of the
            ! agents payoffs. These feed into the simulation of choice
            ! probabilities.
            k = mapping_state_idx(period + 1, exp_a + 1, exp_b + 1, edu + 1, edu_lagged + 1)
            payoffs_systematic = periods_payoffs_systematic(period + 1, k + 1, :)

            ! Extract relevant deviates from standard normal distribution.
            draws_prob_raw = periods_draws_prob(period + 1, :, :)

            ! Prepare to calculate product of likelihood contributions.
            crit_val_contrib = 1.0

            ! If an agent is observed working, then the the labor market shocks
            ! are observed and the conditional distribution is used to determine
            ! the choice probabilities.
            IF (is_working) THEN

                ! Calculate the disturbance, which follows a normal
                ! distribution.
                dist = LOG(data_array(j, 4)) - LOG(payoffs_systematic(idx))

                ! Construct independent normal draws implied by the observed
                ! wages.
                !IF (choice == 1) THEN
                !    draws_prob(:, idx) = dist / sqrt(shocks_cov(idx, idx))
                !ELSE
                !    draws_prob(:, idx) = (dist - shocks_cholesky(idx, 1) * draws_prob(:, 1)) / shocks_cholesky(idx, idx)
                !END IF

                ! Record contribution of wage observation.  
                !crit_val_contrib =  crit_val_contrib * normal_pdf(dist, zero_dble, sqrt(shocks_cov(idx, idx)))

                ! If there is no random variation in payoffs, then the
                ! observed wages need to be identical their systematic
                ! components. The discrepancy between the observed wages and
                ! their systematic components might be small due to the
                ! reading in of the dataset.
                IF (is_deterministic) THEN
                    IF (dist .GT. SMALL_FLOAT) THEN
                        rslt = zero_dble
                        RETURN
                    END IF
                END IF


            END IF

            ! Simulate the conditional distribution of alternative-specific
            ! value functions and determine the choice probabilities.
            counts = 0
            prob_obs = 0.0

            ! Determine conditional deviates. These correspond to the
            ! unconditional draws if the agent did not work in the labor market.
            !DO s = 1, num_draws_prob
            !    conditional_draws(s, :) = &
            !        MATMUL(draws_prob(s, :), TRANSPOSE(shocks_cholesky))
            !END DO

            !counts = 0

            DO s = 1, num_draws_prob
                ! Extract deviates from (un-)conditional normal distributions.
                draws_stan = draws_prob_raw(s, :)

                ! Construct independent normal draws implied by the agents
                ! state experience. This is need to maintain the correlation
                ! structure of the disturbances.
                IF (is_working) THEN 

                    IF (choice == 1) THEN
                        draws_stan(idx) = dist / sqrt(shocks_cov(idx, idx))
                    ELSE
                        draws_stan(idx) = (dist - shocks_cholesky(idx, 1) * draws_stan(1)) / shocks_cholesky(idx, idx)
                    END IF

                    prob_wage = normal_pdf(draws_stan(idx), zero_dble, sqrt(shocks_cov(idx, idx)))

                ELSE 
                    prob_wage = one_dble
                END IF

                ! As deviates are aligned with the state experiences, create
                ! the conditional draws. Note, that the realization of the
                ! random component of wages align withe their observed
                ! counterpart in the data.
                draws_cond = MATMUL(draws_stan, TRANSPOSE(shocks_cholesky))

                ! Extract deviates from (un-)conditional normal distributions
                ! and transform labor market shocks.
                draws = draws_cond
                draws(:2) = EXP(draws(:2))

                ! Calculate total payoff.
                CALL get_total_value(total_payoffs, period, num_periods, &
                        delta, payoffs_systematic, draws, edu_max, edu_start, &
                        mapping_state_idx, periods_emax, k, states_all)

                ! Record optimal choices
                counts(MAXLOC(total_payoffs)) = counts(MAXLOC(total_payoffs)) + 1

                ! Get the smoothed choice probability.
                ! TODO: Refactor
                maxim_payoff = MAXVAL(total_payoffs)
                smoot_payoff = EXP((total_payoffs - maxim_payoff)/tau)
                prob_choice = (smoot_payoff(idx) / SUM(smoot_payoff))
                
                !prob_choice = get_smoothed_probability(total_payoffs, idx, tau)               
                prob_obs = prob_obs + prob_choice * prob_wage

            END DO
            ! Determine relative shares
            prob_obs = prob_obs / num_draws_prob


            ! Determine relative shares. Special care required due to integer
            ! arithmetic, transformed to mixed mode arithmetic.
            !choice_probabilities = counts / DBLE(num_draws_prob)

            ! If there is no random variation in payoffs, then this implies a
            ! unique optimal choice.
            ! TODO: THIS IS NOT ALIGNED
            IF (is_deterministic) THEN
                IF  ((MAXVAL(counts) .EQ. num_draws_prob) .EQV. .FALSE.) THEN
                    rslt = zero_dble
                    RETURN
                END IF
            END IF

            ! Adjust  and record likelihood contribution
            !crit_val_contrib = crit_val_contrib * choice_probabilities(idx)
            crit_val(j) = prob_obs

            j = j + 1

        END DO

    END DO

    ! Scaling
    DO i = 1, num_agents * num_periods
        crit_val(i) = clip_value(crit_val(i), TINY_FLOAT, HUGE_FLOAT)
    END DO

    rslt = -SUM(LOG(crit_val)) / (num_agents * num_periods)

    ! If there is no random variation in payoffs and no agent violated the
    ! implications of observed wages and choices, then the evaluation return
    ! a value of one.
    IF (is_deterministic) THEN
        rslt = 1.0
    END IF
    
END SUBROUTINE
!*******************************************************************************
!*******************************************************************************
END MODULE