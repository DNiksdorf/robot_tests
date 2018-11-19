*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***
${RESOURCE}             tenders
@{USED_ROLES}           viewer
${FEED_ITEMS_NUMBER}    10

*** Test Cases ***
Можливість переглянути тендери
  [Tags]   ${USERS.users['${viewer}'].broker}: Читання тендерів
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_feed
  ...      critical
  Можливість прочитати тендери для користувача ${viewer}


Можливість переглянути договори
  [Tags]   ${USERS.users['${viewer}'].broker}: Читання контрактів
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_feed
  ...      critical
  Можливість прочитати договори для користувача ${viewer}
