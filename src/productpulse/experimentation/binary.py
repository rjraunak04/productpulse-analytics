"""Two-arm binary experiment analysis using normal approximations."""

from dataclasses import dataclass
from math import erf,sqrt


def _normal_cdf(x: float) -> float:
    return 0.5*(1.0+erf(x/sqrt(2.0)))


@dataclass(frozen=True)
class BinaryExperimentResult:
    control_rate: float
    treatment_rate: float
    absolute_uplift: float
    relative_uplift: float | None
    ci_low: float
    ci_high: float
    z_statistic: float
    p_value: float
    statistically_significant: bool
    practically_significant: bool


def analyze_binary_metric(
    control_successes: int,
    control_n: int,
    treatment_successes: int,
    treatment_n: int,
    alpha: float=0.05,
    minimum_practical_uplift: float=0.0,
) -> BinaryExperimentResult:
    for successes,n in ((control_successes,control_n),(treatment_successes,treatment_n)):
        if n<=0 or successes<0 or successes>n:
            raise ValueError("invalid binary metric counts")
    if not 0<alpha<1:
        raise ValueError("alpha must be between 0 and 1")

    pc=control_successes/control_n
    pt=treatment_successes/treatment_n
    diff=pt-pc
    se_unpooled=sqrt(pc*(1-pc)/control_n + pt*(1-pt)/treatment_n)
    pooled=(control_successes+treatment_successes)/(control_n+treatment_n)
    se_pooled=sqrt(pooled*(1-pooled)*(1/control_n+1/treatment_n))

    z=0.0 if se_pooled==0 else diff/se_pooled
    p=2*(1-_normal_cdf(abs(z)))
    # 1.95996398454 is the two-sided 95% normal critical value.
    # v1 contract uses alpha=.05; other alpha values require an explicit extension.
    if abs(alpha-0.05)>1e-12:
        raise ValueError("v1 confidence interval currently supports alpha=0.05")
    critical=1.95996398454
    margin=critical*se_unpooled

    return BinaryExperimentResult(
        control_rate=pc,
        treatment_rate=pt,
        absolute_uplift=diff,
        relative_uplift=None if pc==0 else diff/pc,
        ci_low=diff-margin,
        ci_high=diff+margin,
        z_statistic=z,
        p_value=p,
        statistically_significant=p<alpha,
        practically_significant=abs(diff)>=minimum_practical_uplift,
    )
