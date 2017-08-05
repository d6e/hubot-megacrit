# Description:
#   Pins builds for megacrit
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot pin <url to ephemeral megacrit-releases build> - Pins the build

LAMBDA_PIN_URL = process.env.LAMBDA_PIN_URL
LAMBDA_PIN_API_KEY = process.env.LAMBDA_PIN_API_KEY

module.exports = (robot) ->
    robot.respond /pin (.*)/i, (res) ->
        url = res.match[1]
        if url.indexOf("http", 0) == -1
            res.reply "The url `#{url}` is not a valid url."
        else if url.indexOf("pinned", 0) != -1
            res.reply "The url `#{url}` is already pinned!"
        else if url.indexOf("megacrit-releases/r", 0) == -1
            res.reply "This url `#{url}` is not using the `megacrit-releases` bucket."
        else
            res.reply "Pinning..."
            data = JSON.stringify({
                "url": url
            })
            robot.http(LAMBDA_PIN_URL)
              .headers("Content-Type": "application/json",
                       "x-api-key": LAMBDA_PIN_API_KEY)
              .put(data) (err, msg, body) ->
                data = JSON.parse body
                res.reply "Pinned to: `#{data.new_url}`"
                if err
                    error = "ERROR: err: #{err}, msg: #{msg}, body: #{body}"
                    res.reply error
                    robot.emit 'error', err, msg
                    robot.logger.error error
