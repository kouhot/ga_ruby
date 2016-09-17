#!/usr/bin/env ruby
# coding: utf-8
require 'google/api_client'
#require 'google/apis/adsense_v1_4'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require 'google/api_client/auth/file_storage'
require 'date'

CLINET_SECRET = 'client_secret.json'
CALENDAR_ID   = 'yours'

client = Google::APIClient.new(:application_name => '')

# 認証
authfile = Google::APIClient::FileStorage.new('.authfile')
unless authfile.authorization.nil?
  client.authorization = authfile.authorization
else
  client_secrets = Google::APIClient::ClientSecrets.load(CLINET_SECRET)

  flow = Google::APIClient::InstalledAppFlow.new(
    :client_id => client_secrets.client_id,
    :client_secret => client_secrets.client_secret,
    :scope => ['https://www.googleapis.com/auth/calendar']
  )
  client.authorization = flow.authorize(authfile)
end

# イベント取得
cal = client.discovered_api('calendar', 'v3')

start_date = '2016-12-28'
end_date = (Date.parse('2016-12-30')+1).to_s

event = {
  'summary' => 'from calendar API！',
  'start' => {
    'date' => '2016-12-28',
  },
  'end' => {
    'date' => "#{end_date}",
  },
  "attendees": [
    {
      "email":"example@example.com",
      "optional":true,
      "responseStatus":"needsAction",
      "comment":"任意参加者です。"
    },
    {
      "email":"example@example.com",
      "optional":true,
      "responseStatus":"needsAction",
      "comment":"任意参加者です"
    }
  ],
  "summary":"title",
  "location":"会議室",
  "description":"新規案件打ち合わせ"
}

result = client.execute(:api_method => cal.events.insert,
                        :parameters => {'calendarId' => CALENDAR_ID},
                        :body => JSON.dump(event),
                        :headers => {'Content-Type' => 'application/json'})

p result.status
