if [ "$(date +%u)" = 7 ]; then rake schedule:all && curl https://api.honeybadger.io/v1/check_in/xoIGwj; fi