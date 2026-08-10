"""Checks for sql/08-dates-and-times.

    pytest sql/08-dates-and-times

One test per question in tests/questions.py. Each runs your exercises/qNN.sql
and compares the result with the model answer. Questions you have not started
are reported as skipped, not failed.
"""


def test_question(q, sql_answer):
    sql_answer.check(q["id"], ordered=q["ordered"])
