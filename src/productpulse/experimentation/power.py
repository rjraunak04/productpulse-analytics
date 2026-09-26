"""Approximate two-arm sample-size planning for binary metrics."""

from math import ceil,sqrt


def approximate_sample_size_per_arm(
    baseline_rate: float,
    absolute_mde: float,
    z_alpha_two_sided: float=1.95996398454,
    z_power: float=0.84162123357,
) -> int:
    treatment_rate=baseline_rate+absolute_mde
    if not 0<baseline_rate<1 or not 0<treatment_rate<1 or absolute_mde<=0:
        raise ValueError("rates and MDE must define valid probabilities")
    pooled=(baseline_rate+treatment_rate)/2
    numerator=(
        z_alpha_two_sided*sqrt(2*pooled*(1-pooled))
        + z_power*sqrt(baseline_rate*(1-baseline_rate)+treatment_rate*(1-treatment_rate))
    )**2
    return ceil(numerator/(absolute_mde**2))
