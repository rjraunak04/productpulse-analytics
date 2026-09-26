"""Sample-ratio-mismatch check for two-arm experiments."""

from math import erfc,sqrt


def sample_ratio_mismatch(
    control_n: int,treatment_n: int,expected_control_share: float=0.5,alpha: float=0.01
) -> dict:
    total=control_n+treatment_n
    if total<=0:
        raise ValueError("experiment must contain assignments")
    if control_n<0 or treatment_n<0:
        raise ValueError("assignment counts cannot be negative")
    if not 0<expected_control_share<1:
        raise ValueError("expected share must be between 0 and 1")

    expected_c=total*expected_control_share
    expected_t=total*(1-expected_control_share)
    chi2=(control_n-expected_c)**2/expected_c+(treatment_n-expected_t)**2/expected_t
    # df=1 chi-square survival function = erfc(sqrt(x/2))
    p_value=erfc(sqrt(chi2/2))
    return {"chi_square":chi2,"p_value":p_value,"srm_detected":p_value<alpha}
