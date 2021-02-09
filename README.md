# Links tracker app

# Setup
1. install dependencies
    ```
    bundle install
    ```

2. start the development server
    ```
    shotgun
    ```

3. service available on 127.0.0.1:9393

---

* to run tests:
    ```
    rake test
    ```

---

# API:

* POST /visited_links, ```{"links": []}```

* GET /visited_domains?from=```timestamp```&to=```timestamp```