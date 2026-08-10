"""Checks for sql/07-case-and-conditional-logic.

    pytest sql/07-case-and-conditional-logic

One test per question in tests/questions.py. Each runs your exercises/qNN.sql
and compares the result with the model answer. Questions you have not started
are reported as skipped, not failed.
"""


def test_question(q, sql_answer):
    sql_answer.check(q["id"], ordered=q["ordered"])
