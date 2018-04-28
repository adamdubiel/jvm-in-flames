wrk.method = "POST"
wrk.headers["Content-Type"] = "application/json"
wrk.body = '{"content": "some_content", "random_number": ' .. math.random(1, 100000) .. '}'
