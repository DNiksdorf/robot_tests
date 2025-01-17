*** Settings ***
Resource           base_keywords.robot
Suite Setup        Test Suite Setup
Suite Teardown     Test Suite Teardown


*** Variables ***
${MODE}         negotiation
@{USED_ROLES}   tender_owner  viewer

${NUMBER_OF_ITEMS}  ${2}
${NUMBER_OF_LOTS}   ${0}
${NUMBER_OF_MILESTONES}  ${3}
${TENDER_MEAT}      ${False}
${LOT_MEAT}         ${False}
${ITEM_MEAT}        ${False}
${MOZ_INTEGRATION}  ${False}
${VAT_INCLUDED}     ${True}
${ROAD_INDEX}       ${False}
${GMDN_INDEX}       ${False}
${PLAN_TENDER}      ${True}

*** Test Cases ***
##############################################################################################
#             MAIN
##############################################################################################

Можливість створити переговорну процедуру
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість створити процедуру
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  create_tender
  ...  level1
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер


Можливість додати документацію до переговорної процедури
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість додати документацію до процедури
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  add_tender_doc
  ...  level2
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати документацію до тендера


Можливість зареєструвати і підтвердити постачальника до переговорної процедури
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість зареєструвати і підтвердити постачальника до процедури
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  add_award
  ...  level1
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість зареєструвати, додати документацію і підтвердити першого постачальника до закупівлі


Можливість знайти переговорну процедуру по ідентифікатору
  [Tags]  ${USERS.users['${viewer}'].broker}: Можливість знайти процедуру
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  find_tender
  ...  level1
  ...  critical
  Можливість знайти тендер по ідентифікатору для користувача ${viewer}

##############################################################################################
#             MAIN DATA
##############################################################################################

Відображення заголовку переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view_title
  ...  level2
  ...  non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title тендера для користувача ${viewer}


Відображення заголовку переговорної процедури англійською мовою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view_title_en
  ...  non-critical
  Звірити відображення поля title_en тендера для користувача ${viewer}


Відображення заголовку переговорної процедури російською мовою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view_title_ru
  ...  non-critical
  Звірити відображення поля title_ru тендера для користувача ${viewer}


Відображення ідентифікатора переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level2
  ...  critical
  Звірити відображення поля tenderID тендера із ${TENDER['TENDER_UAID']} для користувача ${viewer}


Відображення опису переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view_description
  ...  level3
  ...  critical
  Звірити відображення поля description тендера для користувача ${viewer}


Відображення опису переговорної процедури англійською мовою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view_description_en
  ...  non-critical
  Звірити відображення поля description_en тендера для користувача ${viewer}


Відображення опису переговорної процедури російською мовою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view_description_ru
  ...  non-critical
  Звірити відображення поля description_ru тендера для користувача ${viewer}


Відображення підстави вибору переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view_cause_description
  ...  level2
  ...  critical
  Звірити відображення поля causeDescription тендера для користувача ${viewer}


Відображення обгрунтування причини вибору переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view_cause
  ...  level2
  ...  critical
  Звірити відображення поля cause тендера для користувача ${viewer}


Відображення типу оплати
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_milestone  level2
  ...      non-critical
  Звірити відображення поля code усіх умов оплати для користувача ${viewer}


Відображення події яка ініціює оплату
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_milestone  level2
  ...      non-critical
  Звірити відображення поля title усіх умов оплати для користувача ${viewer}


Відображення розміру оплати
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_milestone  level2
  ...      non-critical
  Звірити відображення поля percentage усіх умов оплати для користувача ${viewer}


Відображення к-ті днів періоду оплати
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_milestone  level2
  ...      non-critical
  Звірити відображення поля duration.days усіх умов оплати для користувача ${viewer}


Відображення типу днів періоду оплати
    [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_milestone  level2
  ...      non-critical
  Звірити відображення поля duration.type усіх умов оплати для користувача ${viewer}


Відображення виду предмету закупівлі тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      non-critical
  Звірити відображення поля mainProcurementCategory тендера для користувача ${viewer}


##############################################################################################
#             MAIN DATA.VALUE
##############################################################################################

Відображення бюджету переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення бюджету процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level2
  ...  critical
  Звірити відображення поля value.amount тендера для користувача ${viewer}


Відображення валюти переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення бюджету процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  critical
  Звірити відображення поля value.currency тендера для користувача ${viewer}


Відображення врахованого податку в бюджет переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення бюджету процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля value.valueAddedTaxIncluded тендера для користувача ${viewer}

##############################################################################################
#             MAIN DATA.PROCURING ENTITY
##############################################################################################

Відображення країни замовника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  non-critical
  Звірити відображення поля procuringEntity.address.countryName тендера для користувача ${viewer}


Відображення населеного пункту замовника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля procuringEntity.address.locality тендера для користувача ${viewer}


Відображення поштового коду замовника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля procuringEntity.address.postalCode тендера для користувача ${viewer}


Відображення області замовника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля procuringEntity.address.region тендера для користувача ${viewer}


Відображення вулиці замовника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля procuringEntity.address.streetAddress тендера для користувача ${viewer}


Відображення контактного імені замовника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  critical
  Звірити відображення поля procuringEntity.contactPoint.name тендера для користувача ${viewer}


Відображення контактного телефону замовника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  critical
  Звірити відображення поля procuringEntity.contactPoint.telephone тендера для користувача ${viewer}


Відображення сайту замовника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view_contactPoint_url
  ...  level3
  ...  non-critical
  Звірити відображення поля procuringEntity.contactPoint.url тендера для користувача ${viewer}


Відображення офіційного імені замовника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  critical
  Звірити відображення поля procuringEntity.identifier.legalName тендера для користувача ${viewer}


Відображення схеми ідентифікації замовника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  non-critical
  Звірити відображення поля procuringEntity.identifier.scheme тендера для користувача ${viewer}


Відображення ідентифікатора замовника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля procuringEntity.identifier.id тендера для користувача ${viewer}


Відображення імені замовника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля procuringEntity.name тендера для користувача ${viewer}

##############################################################################################
#             MAIN DATA.ITEMS
##############################################################################################

Відображення опису номенклатури переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level2
  ...  non-critical
  Звірити відображення поля description усіх предметів для користувача ${viewer}


Відображення схеми класифікації номенклатур переговорної процедури
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля classification.scheme усіх предметів для користувача ${viewer}
  Run Keyword If  "${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}" == "33600000-6"
  ...      Звірити відображення поля additionalClassifications[0].scheme усіх предметів для користувача ${viewer}


Відображення ідентифікатора класифікації номенклатур переговорної процедури
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля classification.id усіх предметів для користувача ${viewer}
  Run Keyword If  "${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}" == "33600000-6"
  ...      Звірити відображення поля additionalClassifications[0].id усіх предметів для користувача ${viewer}


Відображення опису класифікації номенклатур переговорної процедури
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля classification.description усіх предметів для користувача ${viewer}
  Run Keyword If  "${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}" == "33600000-6"
  ...      Звірити відображення поля additionalClassifications[0].description усіх предметів для користувача ${viewer}


Відображення кількості номенклатури переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level2
  ...  non-critical
  Звірити відображення поля quantity усіх предметів для користувача ${viewer}


Відображення назви одиниці номенклатури переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level2
  ...  non-critical
  Звірити відображення поля unit.name усіх предметів для користувача ${viewer}


Відображення коду одиниці виміру номенклатури переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view_unit_code
  ...  non-critical
  Звірити відображення поля unit.code усіх предметів для користувача ${viewer}


Відображення дати доставки номенклатури переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  critical
  Звірити відображення дати deliveryDate.endDate усіх предметів для користувача ${viewer}


Відображення координат доставки номенклатури переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view_coordinates
  ...  non-critical
  Звірити відображення координат усіх предметів для користувача ${viewer}


Відображення назви країни доставки номенклатури переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view_delivery_address
  ...  level3
  ...  non-critical
  Звірити відображення поля deliveryAddress.countryName усіх предметів для користувача ${viewer}


Відображення назви країни доставки номенклатури переговорної процедури російською мовою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view_delivery_address_ru
  ...  non-critical
  Звірити відображення поля deliveryAddress.countryName_ru усіх предметів для користувача ${viewer}


Відображення назви країни доставки номенклатури переговорної процедури англійською мовою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view_delivery_address_en
  ...  non-critical
  Звірити відображення поля deliveryAddress.countryName_en усіх предметів для користувача ${viewer}


Відображення пошт. коду доставки номенклатури переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля deliveryAddress.postalCode усіх предметів для користувача ${viewer}


Відображення регіону доставки номенклатури переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  critical
  Звірити відображення поля deliveryAddress.region усіх предметів для користувача ${viewer}


Відображення населеного пункту адреси доставки номенклатури переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  critical
  Звірити відображення поля deliveryAddress.locality усіх предметів для користувача ${viewer}


Відображення вулиці доставки номенклатури переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля deliveryAddress.streetAddress усіх предметів для користувача ${viewer}

##############################################################################################
#             DOCUMENTS
##############################################################################################

Відображення заголовку документа переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення документації процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  add_tender_doc
  ...  level3
  ...  non-critical
  Звірити відображення поля documents[0].title тендера із ${USERS.users['${tender_owner}']['tender_document']['doc_name']} для користувача ${viewer}

##############################################################################################
#             AWARDS
##############################################################################################

Відображення документації стосовно доданого постачальника
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level2
  ...  critical
  Звірити відображення поля awards[0].documents[0].title тендера із ${USERS.users['${tender_owner}'].award_doc_name} для користувача ${viewer}


Відображення підтвердженого постачальника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level2
  ...  critical
  Звірити відображення поля awards[0].status тендера із active для користувача ${viewer}


Відображення країни постачальника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  non-critical
  Звірити відображення поля awards[0].suppliers[0].address.countryName тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['address']['countryName']} для користувача ${viewer}


Відображення назви нас. пункту постачальника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  non-critical
  Звірити відображення поля awards[0].suppliers[0].address.locality тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['address']['locality']} для користувача ${viewer}


Відображення поштового коду постачальника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  non-critical
  Звірити відображення поля awards[0].suppliers[0].address.postalCode тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['address']['postalCode']} для користувача ${viewer}


Відображення області постачальника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  non-critical
  Звірити відображення поля awards[0].suppliers[0].address.region тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['address']['region']} для користувача ${viewer}


Відображення вулиці постачальника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  non-critical
  Звірити відображення поля awards[0].suppliers[0].address.streetAddress тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['address']['streetAddress']} для користувача ${viewer}


Відображення контактного телефону постачальника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  critical
  Звірити відображення поля awards[0].suppliers[0].contactPoint.telephone тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['contactPoint']['telephone']} для користувача ${viewer}


Відображення контактного імені постачальника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  critical
  Звірити відображення поля awards[0].suppliers[0].contactPoint.name тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['contactPoint']['name']} для користувача ${viewer}


Відображення контактного імейлу постачальника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  critical
  Звірити відображення поля awards[0].suppliers[0].contactPoint.email тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['contactPoint']['email']} для користувача ${viewer}


Відображення схеми ідентифікації постачальника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  non-critical
  Звірити відображення поля awards[0].suppliers[0].identifier.scheme тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['identifier']['scheme']} для користувача ${viewer}


Відображення офіційного імені постачальника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  non-critical
  Звірити відображення поля awards[0].suppliers[0].identifier.legalName тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['identifier']['legalName']} для користувача ${viewer}


Відображення ідентифікатора постачальника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  non-critical
  Звірити відображення поля awards[0].suppliers[0].identifier.id тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['identifier']['id']} для користувача ${viewer}


Відображення імені постачальника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  non-critical
  Звірити відображення поля awards[0].suppliers[0].name тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['name']} для користувача ${viewer}


Відображення врахованого податку до ціни номенклатури постачальника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  non-critical
  Звірити відображення поля awards[0].value.valueAddedTaxIncluded тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['value']['valueAddedTaxIncluded']} для користувача ${viewer}


Відображення валюти ціни номенклатури постачальника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  non-critical
  Звірити відображення поля awards[0].value.currency тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['value']['currency']} для користувача ${viewer}


Відображення вартості номенклатури постачальника переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level2
  ...  non-critical
  Звірити відображення поля awards[0].value.amount тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['value']['amount']} для користувача ${viewer}

##############################################################################################
#             CONTRACTS
##############################################################################################

Неможливість укласти угоду для переговорної процедури поки не пройде stand-still період
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість укласти угоду для процедури
  ...  ${tender_owner}
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  add_contract
  ...  level2
  ...  critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Run keyword and expect error  *  Можливість укласти угоду для закупівлі


Відображення статусу непідписаної угоди з постачальником переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення угоди з постачальником процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  add_contract
  ...  level2
  ...  critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля contracts[0].status тендера із pending для користувача ${viewer}


Відображення закінчення періоду подачі скарг на пропозицію
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      contract_stand_still
  ...      critical
  ${award_index}=  Отримати останній індекс  awards  ${tender_owner}  ${viewer}
  :FOR  ${username}  IN  ${viewer}
  \  Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  awards[${award_index}].complaintPeriod.endDate


Відображення вартості угоди без урахування ПДВ
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_view
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  ${award}=  Отримати останній элемент  awards  ${tender_owner}  ${viewer}
  Log  ${award}
  ${contract}=  Отримати останній элемент  contracts  ${tender_owner}  ${viewer}
  Log  ${contract}
  Log  ${award.value.amount}
  Звірити відображення поля contracts[${contract_index}].value.amountNet тендера із ${award.value.amount} для користувача ${viewer}


Відображення вартості угоди
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_view
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  ${award}=  Отримати останній элемент  awards  ${tender_owner}  ${viewer}
  Log  ${award}
  ${contract}=  Отримати останній элемент  contracts  ${tender_owner}  ${viewer}
  Log  ${contract}
  Log  ${award.value.amount}
  Звірити відображення поля contracts[${contract_index}].value.amount тендера із ${award.value.amount} для користувача ${viewer}


Можливість редагувати вартість угоди без урахування ПДВ
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract_amount_net
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${award}=  Отримати останній элемент  awards  ${tender_owner}  ${viewer}
  ${contract}=  Отримати останній элемент  contracts  ${tender_owner}  ${viewer}
  ${amount_net}=  create_fake_amount_net  ${award.value.amount}  ${award.value.valueAddedTaxIncluded}  ${contract.value.valueAddedTaxIncluded}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  Set to dictionary  ${USERS.users['${tender_owner}']}  new_amount_net=${amount_net}
  Run As  ${tender_owner}  Редагувати угоду
  ...      ${TENDER['TENDER_UAID']}
  ...      ${contract_index}
  ...      value.amountNet
  ...      ${amount_net}


Можливість редагувати вартість угоди
  ${viewer_data}=  Get From Dictionary  ${USERS.users}  ${viewer}
  ${tender_owner_data}=  Get From Dictionary  ${USERS.users}  ${tender_owner}
  [Tags]   ${tender_owner_data.broker}: Редагування угоди
  ...      tender_owner
  ...      ${tender_owner_data.broker}
  ...      modify_contract_value
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${award}=  Отримати останній элемент  awards  ${tender_owner}  ${viewer}
  ${contract}=  Отримати останній элемент  contracts  ${tender_owner}  ${viewer}
  ${amount}=  create_fake_amount  ${award.value.amount}  ${award.value.valueAddedTaxIncluded}  ${contract.value.valueAddedTaxIncluded}
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  Set to dictionary  ${USERS.users['${tender_owner}']}  new_amount=${amount}
  Run As  ${tender_owner}  Редагувати угоду
  ...      ${TENDER['TENDER_UAID']}
  ...      ${contract_index}
  ...      value.amount
  ...      ${amount}


Можливість укласти угоду для переговорної процедури
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість укласти угоду для процедури
  ...  ${tender_owner}
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  add_contract
  ...  level1
  ...  critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати  ${USERS.users['${viewer}'].tender_data.data.awards[0].complaintPeriod.endDate}
  Можливість укласти угоду для закупівлі


Відображення статусу підписаної угоди з постачальником переговорної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення угоди з постачальником процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  add_contract
  ...  level1
  ...  critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля contracts[0].status тендера із active для користувача ${viewer}
