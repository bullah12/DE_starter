"""Checks for sql/13-data-modelling.

    pytest sql/13-data-modelling

One test per question in tests/questions.py. Each runs your exercises/qNN.sql
and compares the result with the model answer. Questions you have not started
are reported as skipped, not failed.
"""


def test_question(q, sql_answer):
    sql_answer.check(q["id"], ordered=q["ordered"])
