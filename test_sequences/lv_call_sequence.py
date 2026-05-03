from pytestflow.core.sequence import TestSequence
from pytestflow.steps.numeric_limit import numeric_limit_step
from pytestflow.steps.pass_fail import pass_fail_step
from jki_python_bridge_for_labview import labview as lv


def get_vcore_from_labview():
    try:
        lv.connect()
        result = lv.example.add(1, 2)
        lv.disconnect()
        return result
    except Exception as e:
        return e

@numeric_limit_step(name="measure_vcore", limit=(1.0, 1.3), mode="between")
def measure_vcore():
    return get_vcore_from_labview()

@pass_fail_step(name="functional_check")
def functional_check():
    return True


def main_sequence() -> TestSequence:
    return TestSequence(
        name="LabVIEW_Call_Sequence",
        setup_steps=[],
        main_steps=[measure_vcore, functional_check],
        cleanup_steps=[],
    )


PROCESS_HOOKS = {
    "main_sequence": main_sequence,
}
