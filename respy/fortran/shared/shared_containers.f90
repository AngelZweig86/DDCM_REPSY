MODULE shared_containers

    ! This module declares all those variables that are required as part of the evaluation of the criterion function.

    USE shared_constants

    !/* setup                   */

    IMPLICIT NONE

!******************************************************************************
!******************************************************************************
    
    ! Containers required for the evaluation of the criterion function
    INTEGER(our_int), ALLOCATABLE   :: mapping_state_idx(:, :, :, :, :)
    INTEGER(our_int), ALLOCATABLE   :: states_number_period(:)
    INTEGER(our_int), ALLOCATABLE   :: states_all(:, :, :)

    REAL(our_dble), ALLOCATABLE     :: periods_payoffs_systematic(:, :, :)
    REAL(our_dble), ALLOCATABLE     :: periods_draws_prob(:, :, :)
    REAL(our_dble), ALLOCATABLE     :: periods_draws_emax(:, :, :)
    REAL(our_dble), ALLOCATABLE     :: periods_emax(:, :)
    REAL(our_dble), ALLOCATABLE     :: data_est(:, :)

    REAL(our_dble), ALLOCATABLE     :: auto_scales(:, :)

    REAL(our_dble)                  :: x_all_start(26)
    REAL(our_dble)                  :: x_all_current(26)

    REAL(our_dble)                  :: dfunc_eps
    REAL(our_dble)                  :: delta
    REAL(our_dble)                  :: tau

    INTEGER(our_int)                :: edu_start
    INTEGER(our_int)                :: edu_max   

    LOGICAL                         :: is_interpolated
    LOGICAL                         :: paras_fixed(26)
    LOGICAL                         :: is_myopic
    LOGICAL                         :: is_debug

    LOGICAL                         :: crit_estimation = .False.
    LOGICAL                         :: crit_scaled = .False.

    ! Parameters for the optimization
    INTEGER(our_int)                :: maxfun

!******************************************************************************
!******************************************************************************
END MODULE 