*** Settings ***
Library  openprocurement_client_helper.py
Library  openprocurement_client.utils


*** Keywords ***
Отримати internal id по UAid
  [Arguments]  ${username}  ${tender_uaid}
  Log  ${username}
  Log  ${tender_uaid}
  Log Many  ${USERS.users['${username}'].id_map}
  ${status}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${USERS.users['${username}'].id_map}  ${tender_uaid}
  Run Keyword And Return If  ${status}  Get From Dictionary  ${USERS.users['${username}'].id_map}  ${tender_uaid}
  Call Method  ${USERS.users['${username}'].client}  get_tenders
  ${tender_id}=  Wait Until Keyword Succeeds  5x  30 sec  get_tender_id_by_uaid  ${tender_uaid}  ${USERS.users['${username}'].client}
  Set To Dictionary  ${USERS.users['${username}'].id_map}  ${tender_uaid}  ${tender_id}
  [return]  ${tender_id}


Отримати internal id плану по UAid
  [Arguments]  ${username}  ${tender_uaid}
  Log  ${username}
  Log  ${tender_uaid}
  Log Many  ${USERS.users['${username}'].id_map}
  ${status}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${USERS.users['${username}'].id_map}  ${tender_uaid}
  Run Keyword And Return If  ${status}  Get From Dictionary  ${USERS.users['${username}'].id_map}  ${tender_uaid}
  Call Method  ${USERS.users['${username}'].plan_client}  get_plans
  ${tender_id}=  Wait Until Keyword Succeeds  5x  30 sec  get_plan_id_by_uaid  ${tender_uaid}  ${USERS.users['${username}'].plan_client}
  Set To Dictionary  ${USERS.users['${username}'].id_map}  ${tender_uaid}  ${tender_id}
  [return]  ${tender_id}


Отримати internal id об'єкта моніторингу по UAid
  [Arguments]  ${username}  ${monitoring_uaid}
  Log  ${username}
  Log  ${monitoring_uaid}
  Log Many  ${USERS.users['${username}'].id_map}
  ${status}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${USERS.users['${username}'].id_map}  ${monitoring_uaid}
  Run Keyword And Return If  ${status}  Get From Dictionary  ${USERS.users['${username}'].id_map}  ${monitoring_uaid}
  Call Method  ${USERS.users['${username}'].dasu_client}  get_monitorings
  ${monitoring_id}=  Wait Until Keyword Succeeds  5x  30 sec  get_monitoring_id_by_uaid  ${monitoring_uaid}  ${USERS.users['${username}'].dasu_client}
  Set To Dictionary  ${USERS.users['${username}'].id_map}  ${monitoring_uaid}  ${monitoring_id}
  [return]  ${monitoring_id}


Отримати internal id угоди по UAid
  [Arguments]  ${username}  ${agreement_uaid}
  Log  ${username}
  Log  ${agreement_uaid}
  Log Many  ${USERS.users['${username}'].id_map}
  ${status}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${USERS.users['${username}'].id_map}  ${agreement_uaid}
  Run Keyword And Return If  ${status}  Get From Dictionary  ${USERS.users['${username}'].id_map}  ${agreement_uaid}
  Call Method  ${USERS.users['${username}'].agreement_client}  get_agreements
  ${agreement_id}=  Wait Until Keyword Succeeds  5x  30 sec  get_agreement_id_by_uaid  ${agreement_uaid}  ${USERS.users['${username}'].agreement_client}
  Set To Dictionary  ${USERS.users['${username}'].id_map}  ${agreement_uaid}  ${agreement_id}
  [return]  ${agreement_id}


Підготувати клієнт для користувача
  [Arguments]  ${username}
  [Documentation]  Відкрити браузер, створити об’єкти api wrapper і
  ...              ds api wrapper, приєднати їх атрибутами до користувача, тощо
  Log  ${RESOURCE}
  Log  ${API_HOST_URL}
  Log  ${API_VERSION}
  Log  ${DS_HOST_URL}
  ${auth_ds_all}=  get variable value  ${USERS.users.${username}.auth_ds}
  ${auth_ds}=  set variable  ${auth_ds_all.${RESOURCE}}
  Log  ${auth_ds}

  ${ds_config}=  Create Dictionary  host_url=${ds_host_url}  auth_ds=${auth_ds}
  ${plan_api_wrapper}=  prepare_plan_api_wrapper  ${USERS.users['${username}'].api_key}  PLANS  ${API_HOST_URL}  ${API_VERSION}
  ${tender_api_wrapper}=  prepare_api_wrapper  ${USERS.users['${username}'].api_key}  TENDERS  ${API_HOST_URL}  ${API_VERSION}  ${ds_config}
  ${tender_create_wrapper}=  prepare_tender_create_wrapper
  ...  ${USERS.users['${username}'].api_key}
  ...  PLANS
  ...  ${API_HOST_URL}
  ...  ${API_VERSION}
  ...  ${ds_config}
  ${dasu_api_wraper}=  prepare_dasu_api_wrapper
  ...  ${DASU_RESOURCE}
  ...  ${DASU_API_HOST_URL}
  ...  ${DASU_API_VERSION}
  ...  ${USERS.users['${username}'].auth_dasu[0]}
  ...  ${USERS.users['${username}'].auth_dasu[1]}
  ...  ${ds_config}
  ${agreement_wrapper}=  prepare_agreement_api_wrapper  ${USERS.users['${username}'].api_key}  AGREEMENTS  ${API_HOST_URL}  ${API_VERSION}  ${ds_config}
  Set To Dictionary  ${USERS.users['${username}']}  client=${tender_api_wrapper}
  Set To Dictionary  ${USERS.users['${username}']}  plan_client=${plan_api_wrapper}
  Set To Dictionary  ${USERS.users['${username}']}  tender_create_client=${tender_create_wrapper}
  Set To Dictionary  ${USERS.users['${username}']}  agreement_client=${agreement_wrapper}
  Set To Dictionary  ${USERS.users['${username}']}  dasu_client=${dasu_api_wraper}
  Set To Dictionary  ${USERS.users['${username}']}  access_token=${EMPTY}
  ${id_map}=  Create Dictionary
  Set To Dictionary  ${USERS.users['${username}']}  id_map=${id_map}
  Log  ${EDR_HOST_URL}
  Log  ${EDR_VERSION}
  ${edr_wrapper}=  prepare_edr_wrapper  ${EDR_HOST_URL}  ${EDR_VERSION}  ${USERS.users['${username}'].auth_edr[0]}  ${USERS.users['${username}'].auth_edr[1]}
  Set To Dictionary  ${USERS.users['${username}']}  edr_client=${edr_wrapper}
  #Variables for contracting_management module
  ${contract_api_wrapper}=  prepare_contract_api_wrapper  ${USERS.users['${username}'].api_key}  CONTRACTS  ${api_host_url}  ${api_version}  ${ds_config}
  Set To Dictionary  ${USERS.users['${username}']}  contracting_client=${contract_api_wrapper}
  Set To Dictionary  ${USERS.users['${username}']}  contract_access_token=${EMPTY}
  Set To Dictionary  ${USERS.users['${username}']}  agreement_access_token=${EMPTY}
  ${contracts_id_map}=  Create Dictionary
  ${contracts_id_map}=  Create Dictionary
  Set To Dictionary  ${USERS.users['${username}']}  contracts_id_map=${contracts_id_map}
  Log Variables


Завантажити документ
  [Arguments]  ${username}  ${filepath}  ${tender_uaid}
  Log  ${username}
  Log  ${tender_uaid}
  Log  ${filepath}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  upload_document
  ...      ${filepath}
  ...      ${tender.data.id}
  ...      access_token=${tender.access.token}
  Log object data   ${reply}  reply
  #return here is needed to have uploaded doc data in `Завантажити документ в лот` keyword
  [return]  ${reply}


Отримати інформацію із документа
  [Arguments]  ${username}  ${tender_uaid}  ${doc_id}  ${field}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${document}=  get_document_by_id  ${tender.data}  ${doc_id}
  Log  ${document}
  [Return]  ${document['${field}']}


Отримати інформацію про документ
  [Arguments]  ${username}  ${tender_uaid}  ${doc_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${document}=  get_document_by_id  ${tender.data}  ${doc_id}
  ${file_properties}=  Call Method  ${USERS.users['${username}'].client}  get_file_properties  ${document.url}  ${document.hash}
  Log  ${file_properties}
  [return]  ${file_properties}


Отримати документ
  [Arguments]  ${username}  ${tender_uaid}  ${doc_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${document}=  get_document_by_id  ${tender.data}  ${doc_id}
  ${filename}=  download_file_from_url  ${document.url}  ${OUTPUT_DIR}${/}${document.title}
  [return]  ${filename}


Отримати вміст документа
  [Arguments]  ${username}  ${url}
  ${file_name}=  download_file_from_url  ${url}  ${OUTPUT_DIR}${/}file
  ${file_contents}=  Get File  ${OUTPUT_DIR}${/}${file_name}
  [return]  ${file_contents}


Отримати посилання на аукціон для глядача
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}=${Empty}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${object_with_url}=  get_object_by_id  ${tender.data}  ${lot_id}  lots  id
  Log  ${object_with_url}
  ${auctionUrl}=  Get Variable Value  ${object_with_url['auctionUrl']}
  [Return]  ${auctionUrl}


Отримати посилання на аукціон для учасника
  [Arguments]  ${username}  ${tender_uaid}  ${relatedLot}=${Empty}
  ${bid}=  openprocurement_client.Отримати пропозицію  ${username}  ${tender_uaid}
  ${object_with_url}=  get_object_by_id  ${bid.data}  ${relatedLot}  lotValues  relatedLot
  Log  ${object_with_url}
  ${participationUrl}=  Get Variable Value  ${object_with_url['participationUrl']}
  [Return]  ${participationUrl}

##############################################################################
#             Tender operations
##############################################################################

Підготувати дані для оголошення тендера
  [Documentation]  Це слово використовується в майданчиків, тому потрібно, щоб воно було і тут
  [Arguments]  ${username}  ${tender_data}  ${role_name}
  [return]  ${tender_data}


Перевірити наявність повідомлення
  [Arguments]  ${username}  ${msg}
  Log  ${\n}${msg}${\n}  WARN


Створити тендер
  [Arguments]  ${username}  ${tender_data}  ${plan_id}  ${plan_access_token}
  #${file_path}=  Get Variable Value  ${ARTIFACT_FILE}  artifact_plan.yaml
  #${ARTIFACT}=  load_data_from  ${file_path}
  #Log  ${ARTIFACT.tender_owner_access_token}
  #Log  ${ARTIFACT.tender_id}
  ${tender}=  Call Method  ${USERS.users['${username}'].tender_create_client}  create_tender
  ...      ${plan_id}
  ...      ${tender_data}
  ...      access_token=${plan_access_token}
  Log  ${tender}
  ${access_token}=  Get Variable Value  ${tender.access.token}
  ${status}=  Set Variable If  'open' in '${MODE}'  active.tendering  ${EMPTY}
  ${status}=  Set Variable If  'below' in '${MODE}'  active.enquiries  ${status}
  ${status}=  Set Variable If  'selection' in '${MODE}'  draft.pending  ${status}
  ${status}=  Set Variable If  '${status}'=='${EMPTY}'  active   ${status}
  Set To Dictionary  ${tender['data']}  status=${status}
  ${tender}=  Call Method  ${USERS.users['${username}'].client}  patch_tender
  ...      ${tender.data.id}
  ...      ${tender}
  ...      access_token=${tender.access.token}
  Log  ${tender}
  Log  ${\n}${API_HOST_URL}/api/${API_VERSION}/tenders/${tender.data.id}${\n}  WARN
  Set To Dictionary  ${USERS.users['${username}']}   access_token=${access_token}
  Set To Dictionary  ${USERS.users['${username}']}   tender_data=${tender}
  Log   ${USERS.users['${username}'].tender_data}
  [return]  ${tender.data.tenderID}


Створити тендер другого етапу
  [Arguments]  ${username}  ${tender_data}
  ${tender}=  Call Method  ${USERS.users['${username}'].client}  create_tender  ${tender_data}
  Log  ${tender}
  ${access_token}=  Get Variable Value  ${tender.access.token}
  ${status}=  Set Variable If  'open' in '${MODE}'  active.tendering  ${EMPTY}
  ${status}=  Set Variable If  'below' in '${MODE}'  active.enquiries  ${status}
  ${status}=  Set Variable If  'selection' in '${MODE}'  draft.pending  ${status}
  ${status}=  Set Variable If  '${status}'=='${EMPTY}'  active   ${status}
  Set To Dictionary  ${tender['data']}  status=${status}
  ${tender}=  Call Method  ${USERS.users['${username}'].client}  patch_tender
  ...      ${tender.data.id}
  ...      ${tender}
  ...      access_token=${tender.access.token}
  Log  ${tender}
  Log  ${\n}${API_HOST_URL}/api/${API_VERSION}/tenders/${tender.data.id}${\n}  WARN
  Set To Dictionary  ${USERS.users['${username}']}   access_token=${access_token}
  Set To Dictionary  ${USERS.users['${username}']}   tender_data=${tender}
  Log   ${USERS.users['${username}'].tender_data}
  [return]  ${tender.data.tenderID}


Створити об'єкт моніторингу
  [Arguments]  ${username}  ${monitoring_data}
  ${monitoring}=  Call Method  ${USERS.users['${username}'].dasu_client}  create_monitoring  ${monitoring_data}
  Log  ${monitoring}
  ${access_token}=  Get Variable Value  ${monitoring.access.token}
  Log  ${\n}${DASU_API_HOST_URL}/api/${DASU_API_VERSION}/monitorings/${monitoring.data.id}${\n}  WARN
  Set To Dictionary  ${USERS.users['${username}']}   access_token=${access_token}
  Set To Dictionary  ${USERS.users['${username}']}   monitoring_data=${monitoring}
  Log   ${USERS.users['${username}'].monitoring_data}
  [return]  ${monitoring.data.monitoring_id}


Оприлюднити рішення про початок моніторингу
  [Arguments]  ${username}  ${monitoring_uaid}  ${file_path}  ${monitoring_data}
  ${document}=  Call Method  ${USERS.users['${username}'].dasu_client}  upload_obj_document  ${file_path}
  ${documents}=  Create List
  Append To List  ${documents}  ${document.data}
  Set To Dictionary  ${monitoring_data.data.decision}  documents=${documents}
  Log  ${monitoring_data}
  ${monitoring_id}=  Set Variable  ${USERS.users['${username}'].monitoring_data.data.id}
  ${reply}=  Call Method  ${USERS.users['${username}'].dasu_client}  patch_monitoring  ${monitoring_data}  ${monitoring_id}
  Log  ${reply}
  Set To Dictionary  ${USERS.users['${dasu_user}'].initial_data.data}  decision=${monitoring_data.data.decision}
  Set To Dictionary  ${USERS.users['${username}']}   monitoring_data=${reply}
  [return]  ${reply}


Створити план
  [Arguments]  ${username}  ${tender_data}
  ${tender}=  Call Method  ${USERS.users['${username}'].plan_client}  create_plan  ${tender_data}
  Log  ${tender}
  ${access_token}=  Get Variable Value  ${tender.access.token}
  ${tender}=  Call Method  ${USERS.users['${username}'].plan_client}  patch_plan
  ...      ${tender.data.id}
  ...      ${tender}
  ...      access_token=${tender.access.token}
  Log  ${tender}
  Log  ${\n}${API_HOST_URL}/api/${API_VERSION}/plans/${tender.data.id}${\n}  WARN
  Set To Dictionary  ${USERS.users['${username}']}   access_token=${access_token}
  Set To Dictionary  ${USERS.users['${username}']}   tender_data=${tender}
  Log   ${USERS.users['${username}'].tender_data}
  [return]  ${tender.data.planID}


Отримати список тендерів
  [Arguments]  ${username}
  @{tenders_feed}=  get_tenders_feed  ${USERS.users['${username}'].client}
  [return]  @{tenders_feed}


Отримати тендер по внутрішньому ідентифікатору
  [Arguments]  ${username}  ${internalid}  ${save_key}=tender_data
  ${tender}=  Call Method  ${USERS.users['${username}'].client}  get_tender  ${internalid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  Set To Dictionary  ${USERS.users['${username}']}  ${save_key}=${tender}
  ${tender}=  munch_dict  arg=${tender}
  Log  ${tender}
  [return]   ${tender}


Пошук тендера по ідентифікатору
  [Arguments]  ${username}  ${tender_uaid}  ${save_key}=tender_data
  ${internalid}=  openprocurement_client.Отримати internal id по UAid  ${username}  ${tender_uaid}
  ${tender}=  openprocurement_client.Отримати тендер по внутрішньому ідентифікатору  ${username}  ${internalid}  ${save_key}
  [return]  ${tender}


Пошук об'єкта моніторингу по ідентифікатору
  [Arguments]  ${username}  ${monitoring_uaid}  ${save_key}=monitoring_data
  ${internalid}=  openprocurement_client.Отримати internal id об'єкта моніторингу по UAid  ${username}  ${monitoring_uaid}
  ${monitoring}=  Call Method  ${USERS.users['${username}'].dasu_client}  get_monitoring  ${internalid}
  Set To Dictionary  ${USERS.users['${username}']}  ${save_key}=${monitoring}
  ${monitoring}=  munch_dict  arg=${monitoring}
  Log  ${monitoring}
  [return]   ${monitoring}


Пошук угоди по ідентифікатору
  [Arguments]  ${username}  ${agreement_uaid}  ${save_key}=agreement_data
  ${internalid}=  openprocurement_client.Отримати internal id угоди по UAid  ${username}  ${agreement_uaid}
  ${agreement}=  Call Method  ${USERS.users['${username}'].agreement_client}  get_agreement  ${internalid}
  Set To Dictionary  ${USERS.users['${username}']}  ${save_key}=${agreement}
  ${agreement}=  munch_dict  arg=${agreement}
  Log  ${agreement}
  [return]   ${agreement}


Отримати доступ до об'єкта моніторингу
  [Arguments]  ${username}  ${monitoring_uaid}  ${save_key}=monitoring
  ${token}=  Set Variable  ${USERS.users['${username}'].access_token}
  ${internalid}=  openprocurement_client.Отримати internal id об'єкта моніторингу по UAid  ${username}  ${monitoring_uaid}
  ${monitoring}=  Call Method  ${USERS.users['${username}'].dasu_client}  patch_credentials  ${internalid}  ${token}
  Set To Dictionary  ${USERS.users['${username}']}  ${save_key}=${monitoring}
  Log  ${USERS.users['${username}'].monitoring_data}
  ${monitoring}=  munch_dict  arg=${monitoring}
  [return]   ${monitoring}


Додати учасника процесу моніторингу
  [Arguments]  ${username}  ${monitoring_uaid}  ${party_data}
  ${monitoring}=  openprocurement_client.Пошук об'єкта моніторингу по ідентифікатору  ${username}  ${monitoring_uaid}
  Log  ${monitoring}
  ${party}=  Call Method  ${USERS.users['${username}'].dasu_client}  create_party  ${monitoring}  ${party_data}
  Log  ${party}
  ${monitoring}=  openprocurement_client.Пошук об'єкта моніторингу по ідентифікатору  ${username}  ${monitoring_uaid}
  Set To Dictionary  ${USERS.users['${username}']}   monitoring_data=${monitoring}
  Log  ${USERS.users['${username}'].monitoring_data}
  [return]  ${monitoring}


Запитати в замовника пояснення
  [Arguments]  ${username}  ${monitoring_uaid}  ${post_data}
  ${monitoring}=  openprocurement_client.Пошук об'єкта моніторингу по ідентифікатору  ${username}  ${monitoring_uaid}
  ${post}=  Call Method  ${USERS.users['${username}'].dasu_client}  create_post  ${monitoring}  ${post_data}
  Log  ${post}
  ${monitoring}=  openprocurement_client.Пошук об'єкта моніторингу по ідентифікатору  ${username}  ${monitoring_uaid}
  Set To Dictionary  ${USERS.users['${username}']}   monitoring_data=${monitoring}
  Log  ${USERS.users['${username}'].monitoring_data}
  [return]  ${monitoring}


Надати відповідь користувачем ДАСУ
  [Arguments]  ${username}  ${monitoring_uaid}  ${post_data}
  ${monitoring}=  openprocurement_client.Запитати в замовника пояснення  ${username}  ${monitoring_uaid}  ${post_data}
  [return]  ${monitoring}


Надати пояснення замовником
  [Arguments]  ${username}  ${monitoring_uaid}  ${post_data}
  Log  ${USERS.users['${username}'].access_token}
  ${monitoring}=  openprocurement_client.Отримати доступ до об'єкта моніторингу  ${username}  ${monitoring_uaid}
  ${post}=  Call Method  ${USERS.users['${username}'].dasu_client}  create_post  ${monitoring}  ${post_data}
  Log  ${post}
  [return]  ${post}


Змінити статус об’єкта моніторингу
  [Arguments]  ${username}  ${monitoring_uaid}  ${status_data}
  ${monitoring_id}=  Set Variable  ${USERS.users['${username}'].monitoring_data.data.id}
  ${reply}=  Call Method  ${USERS.users['${username}'].dasu_client}  patch_monitoring  ${status_data}  ${monitoring_id}
  Log  ${reply}
  Set To Dictionary  ${USERS.users['${username}']}  monitoring_data=${reply}
  [return]  ${reply}


Оприлюднити рішення про усунення порушення
  [Arguments]  ${username}  ${monitoring_uaid}  ${report_data}
  ${monitoring}=  openprocurement_client.Пошук об'єкта моніторингу по ідентифікатору  ${username}  ${monitoring_uaid}
  ${reply}=  Call Method  ${USERS.users['${username}'].dasu_client}  patch_monitoring  ${report_data}  ${monitoring.data.id}
  Log  ${reply}
  Set To Dictionary  ${USERS.users['${username}']}  monitoring_data=${reply}
  [return]  ${reply}


Надати звіт про усунення порушення замовником
  [Arguments]  ${username}  ${monitoring_uaid}  ${resolution_data}  ${file_path}
  ${reply}=  Call Method  ${USERS.users['${username}'].dasu_client}  upload_obj_document  ${file_path}
  ${documents}=  Create List
  Append To List  ${documents}  ${reply.data}
  Set To Dictionary  ${resolution_data.data}  documents=${documents}
  Log  ${resolution_data}
  ${resolution}=  Call Method  ${USERS.users['${username}'].dasu_client}  patch_eliminationReport  ${USERS.users['${username}'].monitoring}  ${resolution_data}
  Log  ${resolution}
  [return]  ${resolution}


Зазначити, що порушення було оскаржено в суді
  [Arguments]  ${username}  ${monitoring_uaid}  ${appeal_data}  ${file_path}
  ${reply}=  Call Method  ${USERS.users['${username}'].dasu_client}  upload_obj_document  ${filepath}
  ${documents}=  Create List
  Append To List  ${documents}  ${reply.data}
  Set To Dictionary  ${appeal_data.data}  documents=${documents}
  Log  ${appeal_data}
  ${appeal}=  Call Method  ${USERS.users['${username}'].dasu_client}  patch_appeal  ${USERS.users['${username}'].monitoring}  ${appeal_data}
  Log  ${appeal}
  [return]  ${appeal}


Надати пояснення замовником з власної ініціативи
  [Arguments]  ${username}  ${monitoring_uaid}  ${post_data}
  ${post}=  Call Method  ${USERS.users['${username}'].dasu_client}  create_post  ${USERS.users['${username}'].monitoring}  ${post_data}
  Log  ${post}
  [return]  ${post}


Надати висновок про наявність/відсутність порушення в тендері
  [Arguments]  ${username}  ${monitoring_uaid}  ${conclusion_data}
  ${monitoring}=  openprocurement_client.Пошук об'єкта моніторингу по ідентифікатору  ${username}  ${monitoring_uaid}
  ${reply}=  Call Method  ${USERS.users['${username}'].dasu_client}  patch_monitoring  ${conclusion_data}  ${monitoring.data.id}
  Log  ${reply}
  Set To Dictionary  ${USERS.users['${username}']}   monitoring_data=${reply}
  [return]  ${reply}


Отримати список планів
  [Arguments]  ${username}
  @{plans_feed}=  get_plans_feed  ${USERS.users['${username}'].plan_client}
  [return]  @{plans_feed}


Отримати план по внутрішньому ідентифікатору
  [Arguments]  ${username}  ${internalid}  ${save_key}=tender_data
  ${tender}=  Call Method  ${USERS.users['${username}'].plan_client}  get_plan  ${internalid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  Set To Dictionary  ${USERS.users['${username}']}  ${save_key}=${tender}
  ${tender}=  munch_dict  arg=${tender}
  Log  ${tender}
  [return]   ${tender}


Пошук плану по ідентифікатору
  [Arguments]  ${username}  ${tender_uaid}  ${save_key}=tender_data
  ${internalid}=  openprocurement_client.Отримати internal id плану по UAid  ${username}  ${tender_uaid}
  ${tender}=  openprocurement_client.Отримати план по внутрішньому ідентифікатору  ${username}  ${internalid}  ${save_key}
  [return]  ${tender}


Отримати тендер другого етапу та зберегти його
  [Arguments]  ${username}  ${tender_uaid}
  ${internalid}=  openprocurement_client.Отримати internal id по UAid  ${username}  ${tender_uaid}
  ${response}=  Call Method  ${USERS.users['${username}'].client}  patch_credentials  ${internalid}  ${USERS.users['${username}'].access_token}
  ${tender}=  set_access_key  ${response}  ${response.access.token}
  Set To Dictionary  ${USERS.users['${username}']}   access_token=${response.access.token}
  Set To Dictionary  ${USERS.users['${username}']}  second_stage_data=${response}
  Log  ${tender.data.tenderID}


Оновити сторінку з тендером
  [Arguments]  ${username}  ${tender_uaid}
  openprocurement_client.Пошук тендера по ідентифікатору    ${username}  ${tender_uaid}


Оновити сторінку з планом
  [Arguments]  ${username}  ${tender_uaid}
  openprocurement_client.Пошук плану по ідентифікатору  ${username}  ${tender_uaid}


Оновити сторінку з об'єктом моніторингу
  [Arguments]  ${username}  ${monitoring_uaid}
  openprocurement_client.Пошук об'єкта моніторингу по ідентифікатору  ${username}  ${monitoring_uaid}


Отримати інформацію із тендера
  [Arguments]  ${username}  ${tender_uaid}  ${field_name}
  openprocurement_client.Пошук тендера по ідентифікатору
  ...      ${username}
  ...      ${tender_uaid}

  ${status}  ${field_value}=  Run keyword and ignore error
  ...      Get from object
  ...      ${USERS.users['${username}'].tender_data.data}
  ...      ${field_name}
  Run Keyword if  '${status}' == 'PASS'  Return from keyword   ${field_value}

  Fail  Field not found: ${field_name}


Отримати інформацію із плану
  [Arguments]  ${username}  ${tender_uaid}  ${field_name}
  openprocurement_client.Пошук плану по ідентифікатору
  ...      ${username}
  ...      ${tender_uaid}

  ${status}  ${field_value}=  Run keyword and ignore error
  ...      Get from object
  ...      ${USERS.users['${username}'].tender_data.data}
  ...      ${field_name}
  Run Keyword if  '${status}' == 'PASS'  Return from keyword   ${field_value}

  Fail  Field not found: ${field_name}


Отримати інформацію із об'єкта моніторингу
  [Arguments]  ${username}  ${monitoring_uaid}  ${field_name}
  openprocurement_client.Пошук об'єкта моніторингу по ідентифікатору
  ...      ${username}
  ...      ${monitoring_uaid}

  ${status}  ${field_value}=  Run keyword and ignore error
  ...      Get from object
  ...      ${USERS.users['${username}'].monitoring_data.data}
  ...      ${field_name}
  Run Keyword if  '${status}' == 'PASS'  Return from keyword   ${field_value}

  Fail  Field not found: ${field_name}


Внести зміни в тендер
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${fieldvalue}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${prev_value}=  Отримати дані із тендера  ${username}  ${tender_uaid}  ${fieldname}
  Set_To_Object  ${tender.data}   ${fieldname}   ${fieldvalue}
  ${procurementMethodType}=  Get From Object  ${tender.data}  procurementMethodType
  Run Keyword If  '${procurementMethodType}' == 'aboveThresholdUA' or '${procurementMethodType}' == 'aboveThresholdEU'
  ...      Remove From Dictionary  ${tender.data}  enquiryPeriod
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  ${tender}=  Call Method  ${USERS.users['${username}'].client}  patch_tender
  ...      ${tender.data.id}
  ...      ${tender}
  ...      access_token=${tender.access.token}
  Run Keyword And Expect Error  *  Порівняти об'єкти  ${prev_value}  ${tender.data.${fieldname}}
  Set_To_Object   ${USERS.users['${username}'].tender_data}   ${fieldname}   ${fieldvalue}


Внести зміни в план
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${fieldvalue}
  ${tender}=  openprocurement_client.Пошук плану по ідентифікатору  ${username}  ${tender_uaid}
  Set_To_Object  ${tender.data}   ${fieldname}   ${fieldvalue}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  ${tender}=  Call Method  ${USERS.users['${username}'].plan_client}  patch_plan
  ...      ${tender.data.id}
  ...      ${tender}
  ...      access_token=${tender.access.token}
  Set_To_Object   ${USERS.users['${username}'].tender_data}   ${fieldname}   ${fieldvalue}

##############################################################################
#             Item operations
##############################################################################

Додати предмет закупівлі
  [Arguments]  ${username}  ${tender_uaid}  ${item}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Append To List  ${tender.data['items']}  ${item}
  Call Method  ${USERS.users['${username}'].client}  patch_tender
  ...      ${tender.data.id}
  ...      ${tender}
  ...      access_token=${tender.access.token}


Додати предмет закупівлі в план
  [Arguments]  ${username}  ${tender_uaid}  ${item}
  ${tender}=  openprocurement_client.Пошук плану по ідентифікатору  ${username}  ${tender_uaid}
  Append To List  ${tender.data['items']}  ${item}
  Call Method  ${USERS.users['${username}'].plan_client}  patch_plan
  ...      ${tender.data.id}
  ...      ${tender}
  ...      access_token=${tender.access.token}


Отримати інформацію із предмету
  [Arguments]  ${username}  ${tender_uaid}  ${item_id}  ${field_name}
  ${field_name}=  Отримати шлях до поля об’єкта  ${username}  ${field_name}  ${item_id}
  Run Keyword And Return  openprocurement_client.Отримати інформацію із тендера  ${username}  ${tender_uaid}  ${field_name}


Видалити предмет закупівлі
  [Arguments]  ${username}  ${tender_uaid}  ${item_id}  ${lot_id}=${Empty}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${item_index}=  get_object_index_by_id  ${tender.data['items']}  ${item_id}
  Remove From List  ${tender.data['items']}  ${item_index}
  Call Method  ${USERS.users['${username}'].client}  patch_tender
  ...      ${tender.data.id}
  ...      ${tender}
  ...      access_token=${tender.access.token}


Видалити предмет закупівлі плану
  [Arguments]  ${username}  ${tender_uaid}  ${item_id}  ${lot_id}=${Empty}
  ${tender}=  openprocurement_client.Пошук плану по ідентифікатору  ${username}  ${tender_uaid}
  ${item_index}=  get_object_index_by_id  ${tender.data['items']}  ${item_id}
  Remove From List  ${tender.data['items']}  ${item_index}
  Call Method  ${USERS.users['${username}'].plan_client}  patch_plan
  ...      ${tender.data.id}
  ...      ${tender}
  ...      access_token=${tender.access.token}

Видалити поле з донора
  [Arguments]  ${username}  ${tender_uaid}  ${funders_index}  ${field_name}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Delete From Dictionary  ${tender.data['funders'][${funders_index}]}  ${field_name}
  Log  ${tender.data['funders'][${funders_index}]}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_tender
  ...      ${tender.data.id}
  ...      ${tender}
  ...      access_token=${tender.access.token}
  Dictionary Should Not Contain Path  ${reply.data['funders'][${funders_index}]}  ${field_name}


Видалити донора
  [Arguments]  ${username}  ${tender_uaid}  ${funders_index}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Remove From List  ${tender.data.funders}  ${funders_index}
  Log  ${tender}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_tender
  ...      ${tender.data.id}
  ...      ${tender}
  ...      access_token=${tender.access.token}
  Log  ${reply}


Додати донора
  [Arguments]  ${username}  ${tender_uaid}  ${funders_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Set To Dictionary  ${tender.data}  funders=@{EMPTY}
  Append To List  ${tender.data.funders}  ${funders_data}
  Log  ${tender}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_tender
  ...      ${tender.data.id}
  ...      ${tender}
  ...      access_token=${tender.access.token}

##############################################################################
#             Lot operations
##############################################################################

Створити лот
  [Arguments]  ${username}  ${tender_uaid}  ${lot}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}   create_lot
  ...      ${tender.data.id}
  ...      ${lot}
  ...      access_token=${tender.access.token}
  #return here is needed to have created lot id in `Створити лот з предметом закупівлі` keyword
  [return]  ${reply}


Створити лот із предметом закупівлі
  [Arguments]  ${username}  ${tender_uaid}  ${lot}  ${item}
  ${reply}=  openprocurement_client.Створити лот  ${username}  ${tender_uaid}  ${lot}
  ${lot_id}=  get_id_from_object  ${lot.data}
  openprocurement_client.Додати предмет закупівлі в лот  ${username}  ${tender_uaid}  ${lot_id}  ${item}


Отримати інформацію із лоту
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}  ${field_name}
  ${field_name}=  Отримати шлях до поля об’єкта  ${username}  ${field_name}  ${lot_id}
  Run Keyword And Return  openprocurement_client.Отримати інформацію із тендера  ${username}  ${tender_uaid}  ${field_name}


Змінити лот
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}   ${fieldname}  ${fieldvalue}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lot_index}=  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  ${lot}=  Create Dictionary  data=${tender.data.lots[${lot_index}]}
  Set_To_Object   ${lot.data}   ${fieldname}   ${fieldvalue}
  ${reply}=  Call Method   ${USERS.users['${username}'].client}  patch_lot
  ...      ${tender.data.id}
  ...      ${lot}
  ...      ${lot.data.id}
  ...      access_token=${tender.access.token}


Додати предмет закупівлі в лот
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}  ${item}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lot_index}=  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  ${lot_id}=  Get Variable Value  ${tender.data.lots[${lot_index}].id}
  Set_To_Object   ${item}   relatedLot   ${lot_id}
  Append To List   ${tender.data['items']}   ${item}
  Call Method   ${USERS.users['${username}'].client}   patch_tender
  ...      ${tender.data.id}
  ...      ${tender}
  ...      access_token=${tender.access.token}


Завантажити документ в лот
  [Arguments]  ${username}  ${filepath}  ${tender_uaid}  ${lot_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lot_index}=  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  ${lot_id}=  Get Variable Value  ${tender.data.lots[${lot_index}].id}
  ${doc}=  openprocurement_client.Завантажити документ  ${username}  ${filepath}  ${tender_uaid}
  ${lot_doc}=  test_lot_document_data  ${doc}  ${lot_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_document
  ...      ${tender.data.id}
  ...      ${lot_doc}
  ...      ${lot_doc.data.id}
  ...      access_token=${tender.access.token}


Видалити лот
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lot_index}=  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  ${lot}=  Create Dictionary  data=${tender.data.lots[${lot_index}]}
  :FOR  ${item}  IN  @{tender.data['items']}
  \  ${item_id}=  get_id_from_object  ${item}
  \  Run Keyword If  '${item.relatedLot}'=='${lot.data.id}'
  \  ...     openprocurement_client.Видалити предмет закупівлі  ${username}  ${tender_uaid}  ${item_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}   delete_lot   ${tender}    ${lot}


Скасувати лот
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}  ${cancellation_reason}  ${document}  ${new_description}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lot_index}=  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  ${lot_id}=  Get Variable Value  ${tender.data.lots[${lot_index}].id}
  ${data}=  Create dictionary
  ...      reason=${cancellation_reason}
  ...      cancellationOf=lot
  ...      relatedLot=${lot_id}
  ${cancellation_data}=  Create dictionary  data=${data}
  ${cancellation_data}=  munch_dict  arg=${cancellation_data}
  ${cancel_reply}=  Call Method  ${USERS.users['${username}'].client}  create_cancellation  ${tender}  ${cancellation_data}
  ${cancellation_id}=  Set variable  ${cancel_reply.data.id}

  ${document_id}=  openprocurement_client.Завантажити документацію до запиту на скасування  ${username}  ${tender_uaid}  ${cancellation_id}  ${document}

  openprocurement_client.Змінити опис документа в скасуванні  ${username}  ${tender_uaid}  ${cancellation_id}  ${document_id}  ${new_description}

  openprocurement_client.Підтвердити скасування закупівлі  ${username}  ${tender_uaid}  ${cancellation_id}


Отримати інформацію з документа до лоту
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}  ${doc_id}  ${field}
  openprocurement_client.Отримати інформацію з документа  ${username}  ${tender_uaid}  ${doc_id}  ${field}


Отримати документ до лоту
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}  ${doc_id}
  Run Keyword And Return  openprocurement_client.Отримати документ  ${username}  ${tender_uaid}  ${doc_id}

##############################################################################
#             Feature operations
##############################################################################

Додати неціновий показник на тендер
  [Arguments]  ${username}  ${tender_uaid}  ${feature}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Append To List  ${tender.data['features']}  ${feature}
  Call Method  ${USERS.users['${username}'].client}  patch_tender
  ...      ${tender.data.id}
  ...      ${tender}
  ...      access_token=${tender.access.token}


Додати неціновий показник на предмет
  [Arguments]  ${username}  ${tender_uaid}  ${feature}  ${item_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${item_index}=  get_object_index_by_id  ${tender.data['items']}  ${item_id}
  ${item_id}=  Get Variable Value  ${tender.data['items'][${item_index}].id}
  Set To Dictionary  ${feature}  relatedItem=${item_id}
  Append To List  ${tender.data['features']}  ${feature}
  Call Method  ${USERS.users['${username}'].client}  patch_tender
  ...      ${tender.data.id}
  ...      ${tender}
  ...      access_token=${tender.access.token}


Додати неціновий показник на лот
  [Arguments]  ${username}  ${tender_uaid}  ${feature}  ${lot_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lot_index}=  get_object_index_by_id  ${tender.data['lots']}  ${lot_id}
  ${lot_id}=  Get Variable Value  ${tender.data['lots'][${lot_index}].id}
  Set To Dictionary  ${feature}  relatedItem=${lot_id}
  Append To List  ${tender.data['features']}  ${feature}
  Call Method  ${USERS.users['${username}'].client}  patch_tender
  ...      ${tender.data.id}
  ...      ${tender}
  ...      access_token=${tender.access.token}


Отримати інформацію із нецінового показника
  [Arguments]  ${username}  ${tender_uaid}  ${feature_id}  ${field_name}
  ${field_name}=  Отримати шлях до поля об’єкта  ${username}  ${field_name}  ${feature_id}
  Run Keyword And Return  openprocurement_client.Отримати інформацію із тендера  ${username}  ${tender_uaid}  ${field_name}


Видалити неціновий показник
  [Arguments]  ${username}  ${tender_uaid}  ${feature_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${feature_index}=  get_object_index_by_id  ${tender.data['features']}  ${feature_id}
  Remove From List  ${tender.data['features']}  ${feature_index}
  Call Method  ${USERS.users['${username}'].client}  patch_tender
  ...      ${tender.data.id}
  ...      ${tender}
  ...      access_token=${tender.access.token}


##############################################################################
#             Questions
##############################################################################

Задати запитання на предмет
  [Arguments]  ${username}  ${tender_uaid}  ${item_id}  ${question}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${item_index}=  get_object_index_by_id  ${tender.data['items']}  ${item_id}
  ${item_id}=  Get Variable Value  ${tender.data['items'][${item_index}].id}
  ${question}=  test_related_question  ${question}  item  ${item_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  create_question
  ...      ${tender.data.id}
  ...      ${question}
  ...      access_token=${tender.access.token}


Задати запитання на лот
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}  ${question}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lot_index}=  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  ${lot_id}=  Get Variable Value  ${tender.data.lots[${lot_index}].id}
  ${question}=  test_related_question  ${question}  lot  ${lot_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  create_question
  ...      ${tender.data.id}
  ...      ${question}
  ...      access_token=${tender.access.token}


Задати запитання на тендер
  [Arguments]  ${username}  ${tender_uaid}  ${question}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  create_question
  ...      ${tender.data.id}
  ...      ${question}
  ...      access_token=${tender.access.token}


Отримати інформацію із запитання
  [Arguments]  ${username}  ${tender_uaid}  ${question_id}  ${field_name}
  ${field_name}=  Отримати шлях до поля об’єкта  ${username}  ${field_name}  ${question_id}
  Run Keyword And Return  openprocurement_client.Отримати інформацію із тендера  ${username}  ${tender_uaid}  ${field_name}


Відповісти на запитання
  [Arguments]  ${username}  ${tender_uaid}  ${answer_data}  ${question_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  ${answer_data.data.id}=  openprocurement_client.Отримати інформацію із запитання  ${username}  ${tender_uaid}  ${question_id}  id
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_question
  ...      ${tender.data.id}
  ...      ${answer_data}
  ...      ${answer_data.data.id}
  ...      access_token=${tender.access.token}

##############################################################################
#             Claims
##############################################################################

Отримати internal id по UAid для скарги
  [Arguments]  ${tender}  ${complaintID}
  ${complaint_internal_id}=  get_complaint_internal_id  ${tender}  ${complaintID}
  [Return]  ${complaint_internal_id}

#Ключові слова типу `* про виправлення умов закупівлі` додані для сумісності з майданчиками

Створити чернетку вимоги про виправлення умов закупівлі
  [Documentation]  Створює вимогу у статусі "draft"
  [Arguments]  ${username}  ${tender_uaid}  ${claim}
  Log  ${claim}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору
  ...      ${username}
  ...      ${tender_uaid}
  ${reply}=  Call Method
  ...      ${USERS.users['${username}'].client}
  ...      create_complaint
  ...      ${tender.data.id}
  ...      ${claim}
  ...      access_token=${tender.access.token}
  Log  ${reply}
  Set To Dictionary  ${USERS.users['${username}']}  complaint_access_token=${reply.access.token}
  [return]  ${reply.data.complaintID}


Створити чернетку вимоги про виправлення умов лоту
  [Documentation]  Створює вимогу у статусі "draft"
  [Arguments]  ${username}  ${tender_uaid}  ${claim}  ${lot_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору
  ...      ${username}
  ...      ${tender_uaid}
  ${lot_index}=  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  Set to dictionary  ${claim.data}  relatedLot=${tender.data.lots[${lot_index}].id}
  ${complaintID}=  openprocurement_client.Створити чернетку вимоги про виправлення умов закупівлі
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${claim}
  [return]  ${complaintID}


Створити чернетку вимоги про виправлення визначення переможця
  [Documentation]  Створює вимогу у статусі "draft"
  [Arguments]  ${username}  ${tender_uaid}  ${claim}  ${award_index}
  Log  ${claim}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору
  ...      ${username}
  ...      ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  ${reply}=  Call Method
  ...      ${USERS.users['${username}'].client}
  ...      create_award_complaint
  ...      ${tender.data.id}
  ...      ${claim}
  ...      ${tender.data.awards[${award_index}].id}
  ...      access_token=${tender.access.token}
  Log  ${reply}
  Set To Dictionary  ${USERS.users['${username}']}  complaint_access_token=${reply.access.token}
  Log  ${USERS.users['${username}'].complaint_access_token}
  [return]  ${reply.data.complaintID}


Створити вимогу про виправлення умов закупівлі
  [Documentation]  Створює вимогу у статусі "claim"
  ...      Можна створити вимогу як з документацією, так і без неї
  [Arguments]  ${username}  ${tender_uaid}  ${claim}  ${document}=${None}

  ${complaintID}=  openprocurement_client.Створити чернетку вимоги про виправлення умов закупівлі
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${claim}

  ${status}=  Run keyword and return status  Should not be equal  ${document}  ${None}
  Log  ${status}
  Run keyword if  ${status} == ${True}  openprocurement_client.Завантажити документацію до вимоги
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${complaintID}
  ...      ${document}

  ${data}=  Create Dictionary  status=claim
  ${confirmation_data}=  Create Dictionary  data=${data}
  openprocurement_client.Подати вимогу
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${complaintID}
  ...      ${confirmation_data}
  [return]  ${complaintID}


Створити вимогу про виправлення умов лоту
  [Documentation]  Створює вимогу у статусі "claim"
  ...      Можна створити вимогу як з документацією, так і без неї
  ...      Якщо lot_index == None, то створюється вимога про виправлення умов тендера.
  [Arguments]  ${username}  ${tender_uaid}  ${claim}  ${lot_id}  ${document}=${None}
  ${complaintID}=  openprocurement_client.Створити чернетку вимоги про виправлення умов лоту
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${claim}
  ...      ${lot_id}

  ${status}=  Run keyword and return status  Should not be equal  ${document}  ${None}
  Log  ${status}
  Run keyword if  ${status} == ${True}  openprocurement_client.Завантажити документацію до вимоги
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${complaintID}
  ...      ${document}

  ${data}=  Create Dictionary  status=claim
  ${confirmation_data}=  Create Dictionary  data=${data}
  openprocurement_client.Подати вимогу
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${complaintID}
  ...      ${confirmation_data}

  [return]  ${complaintID}


Створити вимогу про виправлення визначення переможця
  [Documentation]  Створює вимогу у статусі "claim"
  ...      Можна створити вимогу як з документацією, так і без неї
  [Arguments]  ${username}  ${tender_uaid}  ${claim}  ${award_index}  ${document}=${None}
  ${complaintID}=  openprocurement_client.Створити чернетку вимоги про виправлення визначення переможця
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${claim}
  ...      ${award_index}

  ${status}=  Run keyword and return status  Should not be equal  ${document}  ${None}
  Log  ${status}
  Run keyword if  ${status} == ${True}  openprocurement_client.Завантажити документацію до вимоги про виправлення визначення переможця
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${complaintID}
  ...      ${award_index}
  ...      ${document}

  ${status}=  Set variable  claim
  ${data}=  Create Dictionary  status=${status}
  ${confirmation_data}=  Create Dictionary  data=${data}
  openprocurement_client.Подати вимогу про виправлення визначення переможця
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${complaintID}
  ...      ${award_index}
  ...      ${confirmation_data}

  [return]  ${complaintID}


Створити скаргу про виправлення визначення переможця
  [Documentation]  Створює скаргу у статусі "pending"
  ...      Можна створити скаргу як з документацією, так і без неї
  [Arguments]  ${username}  ${tender_uaid}  ${claim}  ${award_index}  ${document}=${None}
  ${complaintID}=  openprocurement_client.Створити чернетку вимоги про виправлення визначення переможця
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${claim}
  ...      ${award_index}

  ${status}=  Run keyword and return status  Should not be equal  ${document}  ${None}
  Log  ${status}
  Run keyword if  ${status} == ${True}  openprocurement_client.Завантажити документацію до вимоги про виправлення визначення переможця
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${complaintID}
  ...      ${award_index}
  ...      ${document}

  ${status}=  Set variable  pending
  ${data}=  Create Dictionary  status=${status}
  ${confirmation_data}=  Create Dictionary  data=${data}
  openprocurement_client.Подати вимогу про виправлення визначення переможця
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${complaintID}
  ...      ${award_index}
  ...      ${confirmation_data}

  [return]  ${complaintID}


Завантажити документацію до вимоги
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${document}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].complaint_access_token}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  upload_complaint_document
  ...      ${document}
  ...      ${tender.data.id}
  ...      ${complaint_internal_id}
  ...      access_token=${USERS.users['${username}'].complaint_access_token}
  Log  ${tender}
  Log  ${reply}


Завантажити документацію до вимоги про виправлення визначення переможця
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${award_index}  ${document}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору
  ...      ${username}
  ...      ${tender_uaid}
  Log  ${USERS.users['${username}'].complaint_access_token}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].complaint_access_token}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  upload_award_complaint_document
  ...      ${document}
  ...      ${tender.data.id}
  ...      ${tender.data.awards[${award_index}].id}
  ...      ${complaint_internal_id}
  ...      access_token=${USERS.users['${username}'].complaint_access_token}
  Log  ${tender}
  Log  ${reply}


Подати вимогу
  [Documentation]  Переводить вимогу зі статусу "draft" у статус "claim"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${confirmation_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].complaint_access_token}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  Set To Dictionary  ${confirmation_data.data}  id=${complaint_internal_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_complaint
  ...      ${tender.data.id}
  ...      ${confirmation_data}
  ...      ${complaint_internal_id}
  ...      access_token=${USERS.users['${username}'].complaint_access_token}
  Log  ${tender}
  Log  ${reply}


Подати вимогу про виправлення визначення переможця
  [Documentation]  Переводить вимогу зі статусу "draft" у статус "claim"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${award_index}  ${confirmation_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору
  ...      ${username}
  ...      ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].complaint_access_token}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  Set To Dictionary  ${confirmation_data.data}  id=${complaint_internal_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_award_complaint
  ...      ${tender.data.id}
  ...      ${confirmation_data}
  ...      ${tender.data.awards[${award_index}].id}
  ...      ${complaint_internal_id}
  ...      access_token=${tender.access.token}
  Log  ${tender}
  Log  ${reply}


Відповісти на вимогу про виправлення умов закупівлі
  [Documentation]  Переводить вимогу зі статусу "claim" у статус "answered"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${answer_data}
  openprocurement_client.Відповісти на вимогу про виправлення умов лоту
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${complaintID}
  ...      ${answer_data}


Відповісти на вимогу про виправлення умов лоту
  [Documentation]  Переводить вимогу зі статусу "claim" у статус "answered"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${answer_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  Set To Dictionary  ${answer_data.data}  id=${complaint_internal_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_complaint
  ...      ${tender.data.id}
  ...      ${answer_data}
  ...      ${complaint_internal_id}
  ...      access_token=${tender.access.token}
  log  ${tender}
  Log  ${reply}


Відповісти на вимогу про виправлення визначення переможця
  [Documentation]  Переводить вимогу зі статусу "claim" у статус "answered"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${answer_data}  ${award_index}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  Set To Dictionary  ${answer_data.data}  id=${complaint_internal_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_award_complaint
  ...      ${tender.data.id}
  ...      ${answer_data}
  ...      ${tender.data.awards[${award_index}].id}
  ...      ${complaint_internal_id}
  ...      access_token=${tender.access.token}
  log  ${tender}
  Log  ${reply}


Підтвердити вирішення вимоги про виправлення умов закупівлі
  [Documentation]  Переводить вимогу зі статусу "answered" у статус "resolved"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${confirmation_data}
  openprocurement_client.Підтвердити вирішення вимоги про виправлення умов лоту  ${username}  ${tender_uaid}  ${complaintID}  ${confirmation_data}


Підтвердити вирішення вимоги про виправлення умов лоту
  [Documentation]  Переводить вимогу зі статусу "answered" у статус "resolved"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${confirmation_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].complaint_access_token}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  Set To Dictionary  ${confirmation_data.data}  id=${complaint_internal_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_complaint
  ...      ${tender.data.id}
  ...      ${confirmation_data}
  ...      ${complaint_internal_id}
  ...      access_token=${tender.access.token}
  Log  ${reply}


Підтвердити вирішення вимоги про виправлення визначення переможця
  [Documentation]  Переводить вимогу зі статусу "answered" у статус "resolved"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${confirmation_data}  ${award_index}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].complaint_access_token}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  Set To Dictionary  ${confirmation_data.data}  id=${complaint_internal_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_award_complaint
  ...      ${tender.data.id}
  ...      ${confirmation_data}
  ...      ${tender.data.awards[${award_index}].id}
  ...      ${complaint_internal_id}
  ...      access_token=${USERS.users['${username}'].complaint_access_token}
  Log  ${reply}


Скасувати вимогу про виправлення умов закупівлі
  [Documentation]  Переводить вимогу в статус "canceled"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${cancellation_data}
  openprocurement_client.Скасувати вимогу про виправлення умов лоту  ${username}  ${tender_uaid}  ${complaintID}  ${cancellation_data}


Скасувати вимогу про виправлення умов лоту
  [Documentation]  Переводить вимогу в статус "canceled"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${cancellation_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].complaint_access_token}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  Set To Dictionary  ${cancellation_data.data}  id=${complaint_internal_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_complaint
  ...      ${tender.data.id}
  ...      ${cancellation_data}
  ...      ${complaint_internal_id}
  ...      access_token=${USERS.users['${username}'].complaint_access_token}
  Log  ${reply}


Скасувати вимогу про виправлення визначення переможця
  [Documentation]  Переводить вимогу в статус "canceled"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${cancellation_data}  ${award_index}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].complaint_access_token}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  Set To Dictionary  ${cancellation_data.data}  id=${complaint_internal_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_award_complaint
  ...      ${tender.data.id}
  ...      ${cancellation_data}
  ...      ${tender.data.awards[${award_index}].id}
  ...      ${complaint_internal_id}
  ...      access_token=${USERS.users['${username}'].complaint_access_token}
  Log  ${reply}


Перетворити вимогу про виправлення умов закупівлі в скаргу
  [Documentation]  Переводить вимогу у статус "pending"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${escalating_data}
  openprocurement_client.Перетворити вимогу про виправлення умов лоту в скаргу  ${username}  ${tender_uaid}  ${complaintID}  ${escalating_data}


Перетворити вимогу про виправлення умов лоту в скаргу
  [Documentation]  Переводить вимогу у статус "pending"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${escalating_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].complaint_access_token}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  Set To Dictionary  ${escalating_data.data}  id=${complaint_internal_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_complaint
  ...      ${tender.data.id}
  ...      ${escalating_data}
  ...      ${complaint_internal_id}
  ...      access_token=${USERS.users['${username}'].complaint_access_token}
  Log  ${reply}


Перетворити вимогу про виправлення визначення переможця в скаргу
  [Documentation]  Переводить вимогу у статус "pending"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${escalating_data}  ${award_index}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].complaint_access_token}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  Set To Dictionary  ${escalating_data.data}  id=${complaint_internal_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_award_complaint
  ...      ${tender.data.id}
  ...      ${escalating_data}
  ...      ${tender.data.awards[${award_index}].id}
  ...      ${complaint_internal_id}
  ...      access_token=${USERS.users['${username}'].complaint_access_token}
  Log  ${reply}


Отримати інформацію із скарги
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${field_name}  ${award_index}=${None}
  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${complaints}=  Get Variable Value  ${USERS.users['${username}'].tender_data.data.awards[${award_index}].complaints}  ${USERS.users['${username}'].tender_data.data.complaints}
  ${complaint_index}=  get_complaint_index_by_complaintID  ${complaints}  ${complaintID}
  ${field_value}=  Get Variable Value  ${complaints[${complaint_index}]['${field_name}']}
  [Return]  ${field_value}


Отримати інформацію із документа до скарги
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${doc_id}  ${field_name}  ${award_id}=${None}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${document}=  get_document_by_id  ${tender.data}  ${doc_id}
  Log  ${document}
  [Return]  ${document['${field_name}']}


Отримати документ до скарги
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${doc_id}  ${award_id}=${None}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${document}=  get_document_by_id  ${tender.data}  ${doc_id}
  ${filename}=  download_file_from_url  ${document.url}  ${OUTPUT_DIR}${/}${document.title}
  [return]  ${filename}

##############################################################################
#             Bid operations
##############################################################################

Перевірити учасника за ЄДРПОУ
  [Arguments]  ${username}  ${edrpou}
  ${reply}=  Call Method  ${USERS.users['${username}'].edr_client}  verify_member  ${edrpou}
  Log  ${reply}


Подати цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${bid}  ${lots_ids}=${None}  ${features_ids}=${None}
  ${verify_response}=  Run As  ${username}  Перевірити учасника за ЄДРПОУ  ${bid.data.tenderers[0].identifier.id}
  Log  ${verify_response}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lots_ids}=  Run Keyword IF  ${lots_ids}  Set Variable  ${lots_ids}
  ...     ELSE  Create List
  : FOR    ${index}    ${lot_id}    IN ENUMERATE    @{lots_ids}
  \    ${lot_index}=  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  \    ${lot_id}=  Get Variable Value  ${tender.data.lots[${lot_index}].id}
  \    Set To Dictionary  ${bid.data.lotValues[${index}]}  relatedLot=${lot_id}
  ${features_ids}=  Run Keyword IF  ${features_ids}  Set Variable  ${features_ids}
  ...     ELSE  Create List
  : FOR    ${index}    ${feature_id}    IN ENUMERATE    @{features_ids}
  \    ${feature_index}=  get_object_index_by_id  ${tender.data.features}  ${feature_id}
  \    ${code}=  Get Variable Value  ${tender.data.features[${feature_index}].code}
  \    Set To Dictionary  ${bid.data.parameters[${index}]}  code=${code}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  create_bid  ${tender.data.id}  ${bid}
  Log  ${reply}
  Set To Dictionary  ${USERS.users['${username}']}  bid_access_token=${reply.access.token}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].bid_access_token}
  ${procurementMethodType}=  Get variable value  ${USERS.users['${username}'].tender_data.data.procurementMethodType}
  ${methods}=  Create List  competitiveDialogueUA  competitiveDialogueEU  competitiveDialogueEU.stage2  aboveThresholdEU  closeFrameworkAgreementUA  esco
  ${status}=  Set Variable If  '${procurementMethodType}' in ${methods}  pending  active
  Set To Dictionary  ${reply['data']}  status=${status}
  ${reply_active}=  Call Method  ${USERS.users['${username}'].client}  patch_bid
  ...     ${tender.data.id}
  ...     ${reply}
  ...     ${reply.data.id}
  ...     access_token=${tender.access.token}
  Set To Dictionary  ${USERS.users['${username}']}  access_token=${reply['access']['token']}
  Set To Dictionary   ${USERS.users['${username}'].bidresponses['bid'].data}  id=${reply['data']['id']}
  Log  ${reply_active}
  Set To Dictionary  ${USERS.users['${username}']}  bid_id=${reply['data']['id']}
  Log  ${reply}


Змінити цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${fieldvalue}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${bid}=  openprocurement_client.Отримати пропозицію  ${username}  ${tender_uaid}
  Set_To_Object  ${bid.data}   ${fieldname}   ${fieldvalue}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}']['access_token']}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_bid
  ...     ${tender.data.id}
  ...     ${bid}
  ...     ${bid.data.id}
  ...     access_token=${tender.access.token}
  Log  ${reply}


Скасувати цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${bid_id}=  openprocurement_client.Отримати інформацію із пропозиції  ${username}  ${tender_uaid}  id
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  delete_bid
  ...     ${tender.data.id}
  ...     ${bid_id}
  ...     access_token=${USERS.users['${username}']['access_token']}
  Log  ${reply}


Завантажити документ в ставку
  [Arguments]  ${username}  ${path}  ${tender_uaid}  ${doc_name}=documents  ${doc_type}=${None}
  ${bid_id}=  Get Variable Value   ${USERS.users['${username}'].bidresponses['bid'].data.id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}']['access_token']}
  ${response}=  Call Method  ${USERS.users['${username}'].client}  upload_bid_document
  ...      ${path}
  ...      ${tender.data.id}
  ...      ${bid_id}
  ...      doc_type=${doc_type}
  ...      access_token=${tender.access.token}
  ...      subitem_name=${doc_name}
  ${uploaded_file} =  Create Dictionary
  ...      filepath=${path}
  ...      upload_response=${response}
  Log object data   ${uploaded_file}
  [return]  ${uploaded_file}


Змінити документ в ставці
  [Arguments]  ${username}  ${tender_uaid}  ${path}  ${doc_id}  ${doc_type}=documents
  ${bid_id}=  Get Variable Value   ${USERS.users['${username}'].bidresponses['bid'].data.id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}']['access_token']}
  ${bid}=  openprocurement_client.Отримати пропозицію  ${username}  ${tender_uaid}
  ${bid_doc}=  get_document_by_id  ${bid.data}  ${doc_id}
  ${response}=  Call Method  ${USERS.users['${username}'].client}  update_bid_document
  ...      ${path}
  ...      ${tender.data.id}
  ...      ${bid_id}
  ...      ${bid_doc['id']}
  ...      access_token=${tender.access.token}
  ${uploaded_file} =  Create Dictionary
  ...      filepath=${path}
  ...      upload_response=${response}
  Log object data   ${uploaded_file}
  [return]  ${uploaded_file}


Змінити документацію в ставці
  [Arguments]  ${username}  ${tender_uaid}  ${doc_data}  ${doc_id}
  ${bid_id}=  Get Variable Value   ${USERS.users['${username}'].bidresponses['bid'].data.id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}']['access_token']}
  ${bid}=  openprocurement_client.Отримати пропозицію  ${username}  ${tender_uaid}
  ${bid_doc}=  get_document_by_id  ${bid.data}  ${doc_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_bid_document
  ...      ${tender.data.id}
  ...      ${doc_data}
  ...      ${bid_id}
  ...      ${bid_doc['id']}
  ...      access_token=${tender.access.token}


Отримати пропозицію
  [Arguments]  ${username}  ${tender_uaid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${bid_id}=  Get Variable Value  ${USERS.users['${username}'].bid_id}
  ${token}=  Get Variable Value  ${USERS.users['${username}'].access_token}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  get_bid
  ...      ${tender.data.id}
  ...      ${bid_id}
  ...      access_token=${token}
  ${reply}=  munch_dict  arg=${reply}
  [return]  ${reply}


Отримати інформацію із пропозиції
  [Arguments]  ${username}  ${tender_uaid}  ${field}
  ${bid}=  openprocurement_client.Отримати пропозицію  ${username}  ${tender_uaid}
  [return]  ${bid.data.${field}}


##############################################################################
#             Qualification operations
##############################################################################


Отримати список документів по прекваліфікації
  [Documentation]
  ...       [Arguments] Username, tender uaid, qualification id
  ...       [Description] Return all qualification documents by id
  ...       [Return] Reply from API
  [Arguments]  ${username}  ${tender_uaid}  ${qualification_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${doc_list}=  Call Method  ${USERS.users['${username}'].client}  get_qualification_documents
  ...      ${tender.data.id}
  ...      ${qualification_id}
  ...      access_token=${tender.access.token}
  Log  ${doc_list}
  [Return]  ${doc_list}


Отримати список документів по кваліфікації
  [Documentation]
  ...       [Arguments] Username, tender uaid, award id
  ...       [Description] Return all awards documents by id
  ...       [Return] Reply from API
  [Arguments]  ${username}  ${tender_uaid}  ${award_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${doc_list}=  Call Method  ${USERS.users['${username}'].client}  get_awards_documents
  ...      ${tender.data.id}
  ...      ${award_id}
  ...      access_token=${tender.access.token}
  Log  ${doc_list}
  [Return]  ${doc_list}


Отримати останній документ прекваліфікації з типом registerExtract
  [Documentation]
  ...       [Arguments]  Username, tender uaid, qualification id
  ...       [Description] Check documentType in last pre-quailfication document
  ...       [Return] Last document from pre-quailfication
  [Arguments]  ${username}  ${tender_uaid}  ${qualification_id}
  ${docs}=  Run As  ${username}  Отримати список документів по прекваліфікації  ${tender_uaid}  ${qualification_id}
  :FOR  ${item}  IN  @{docs['data']}
  \  ${status}  ${_}=  Run Keyword And Ignore Error  Dictionary Should Contain Key  ${item}  documentType
  \  Run Keyword If  '${status}' == 'PASS'  Exit For Loop
  Log  ${item}
  [Return]  ${item}


Отримати останній документ кваліфікації з типом registerExtract
  [Documentation]
  ...       [Arguments]  Username, tender uaid, award id
  ...       [Description] Check documentType in last award document
  ...       [Return] Last document for
  [Arguments]  ${username}  ${tender_uaid}  ${award_id}
  ${docs}=  Run As  ${username}  Отримати список документів по кваліфікації  ${tender_uaid}  ${award_id}
  :FOR  ${item}  IN  @{docs['data']}
  \  ${status}  ${_}=  Run Keyword And Ignore Error  Dictionary Should Contain Key  ${item}  documentType
  \  Run Keyword If  '${status}' == 'PASS'  Exit For Loop
  Log  ${item}
  [Return]  ${item}


Завантажити документ рішення кваліфікаційної комісії
  [Documentation]
  ...      [Arguments] Username, tender uaid, qualification number and document to upload
  ...      [Description] Find tender using uaid,  and call upload_qualification_document
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${document}  ${tender_uaid}  ${award_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${doc}=  Call Method  ${USERS.users['${username}'].client}  upload_award_document
  ...      ${document}
  ...      ${tender.data.id}
  ...      ${tender.data.awards[${award_num}].id}
  ...      access_token=${tender.access.token}
  Log  ${doc}


Підтвердити постачальника
  [Documentation]
  ...      [Arguments] Username, tender uaid and number of the award to confirm
  ...      Find tender using uaid, create dict with confirmation data and call patch_award
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${award_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${award}=  create_data_dict  data.status  active
  Set To Dictionary  ${award.data}  id=${tender.data.awards[${award_num}].id}
  Run Keyword IF  'open' in '${MODE}'
  ...      Set To Dictionary  ${award.data}
  ...      qualified=${True}
  ...      eligible=${True}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_award
  ...      ${tender.data.id}
  ...      ${award}
  ...      ${award.data.id}
  ...      access_token=${tender.access.token}
  Log  ${reply}


Дискваліфікувати постачальника
  [Documentation]
  ...      [Arguments] Username, tender uaid and award number
  ...      [Description] Find tender using uaid, create data dict with unsuccessful status and call patch_award
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${tender_uaid}  ${award_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${award}=  create_data_dict   data.status  unsuccessful
  Set To Dictionary  ${award.data}  id=${tender.data.awards[${award_num}].id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_award
  ...      ${tender.data.id}
  ...      ${award}
  ...      ${award.data.id}
  ...      access_token=${tender.access.token}
  Log  ${reply}
  [Return]  ${reply}


Скасування рішення кваліфікаційної комісії
  [Documentation]
  ...      [Arguments] Username, tender uaid and award number
  ...      [Description] Find tender using uaid, create data dict with unsuccessful status and call patch_award
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${tender_uaid}  ${award_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${award}=  create_data_dict   data.status  cancelled
  Set To Dictionary  ${award.data}  id=${tender.data.awards[${award_num}].id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_award
  ...      ${tender.data.id}
  ...      ${award}
  ...      ${award.data.id}
  ...      access_token=${tender.access.token}
  Log  ${reply}

##############################################################################
#             Limited procurement
##############################################################################

Створити постачальника, додати документацію і підтвердити його
  [Documentation]
  ...      [Arguments] Username, tender uaid and supplier data
  ...      Find tender using uaid and call create_award, add documentation to that award and update his status to active
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${supplier_data}  ${document}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  create_award  ${tender}  ${supplier_data}
  Log  ${reply}
  ${supplier_number}=  Set variable  0
  openprocurement_client.Завантажити документ рішення кваліфікаційної комісії  ${username}  ${document}  ${tender_uaid}  ${supplier_number}
  openprocurement_client.Підтвердити постачальника  ${username}  ${tender_uaid}  ${supplier_number}


Скасувати закупівлю
  [Documentation]
  ...      [Arguments] Username, tender uaid, cancellation reason,
  ...      document and new description of document
  ...      [Description] Find tender using uaid, set cancellation reason, get data from cancel_tender
  ...      and call create_cancellation
  ...      After that add document to cancellation and change description of document
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${cancellation_reason}  ${document}  ${new_description}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${data}=  Create dictionary  reason=${cancellation_reason}
  ${cancellation_data}=  Create dictionary  data=${data}
  ${cancellation_data}=  munch_dict  arg=${cancellation_data}
  ${cancel_reply}=  Call Method  ${USERS.users['${username}'].client}  create_cancellation
  ...      ${tender.data.id}
  ...      ${cancellation_data}
  ...      access_token=${tender.access.token}
  ${cancellation_id}=  Set variable  ${cancel_reply.data.id}

  ${document_id}=  openprocurement_client.Завантажити документацію до запиту на скасування  ${username}  ${tender_uaid}  ${cancellation_id}  ${document}

  openprocurement_client.Змінити опис документа в скасуванні  ${username}  ${tender_uaid}  ${cancellation_id}  ${document_id}  ${new_description}

  openprocurement_client.Підтвердити скасування закупівлі  ${username}  ${tender_uaid}  ${cancellation_id}


Завантажити документацію до запиту на скасування
  [Documentation]
  ...      [Arguments] Username, tender uaid, cancellation id and document to upload
  ...      [Description] Find tender using uaid, and call upload_cancellation_document
  ...      [Return] ID of added document
  [Arguments]  ${username}  ${tender_uaid}  ${cancellation_id}  ${document}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${doc_reply}=  Call Method  ${USERS.users['${username}'].client}  upload_cancellation_document
  ...      ${document}
  ...      ${tender.data.id}
  ...      ${cancellation_id}
  ...      access_token=${tender.access.token}
  Log  ${doc_reply}
  [Return]  ${doc_reply.data.id}


Змінити опис документа в скасуванні
  [Documentation]
  ...      [Arguments] Username, tender uaid, cancellation id, document id and new description of document
  ...      [Description] Find tender using uaid, create dict with data about description and call
  ...      patch_cancellation_document
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${cancellation_id}  ${document_id}  ${new_description}
  ${field}=  Set variable  description
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${temp}=  Create Dictionary  ${field}=${new_description}
  ${data}=  Create Dictionary  data=${temp}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_cancellation_document
  ...      ${tender.data.id}
  ...      ${data}
  ...      ${cancellation_id}
  ...      ${document_id}
  ...      access_token=${tender.access.token}
  Log  ${reply}


Підтвердити скасування закупівлі
  [Documentation]
  ...      [Arguments] Username, tender uaid, cancellation number
  ...      Find tender using uaid, get cancellation test_confirmation data and call patch_cancellation
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${cancel_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${data}=  test_confirm_data  ${cancel_id}
  Log  ${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_cancellation
  ...      ${tender.data.id}
  ...      ${data}
  ...      ${data.data.id}
  ...      access_token=${tender.access.token}
  Log  ${reply}


Отримати інформацію із документа до скасування
  [Arguments]  ${username}  ${tender_uaid}  ${cancel_id}  ${doc_id}  ${field_name}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${document}=  get_document_by_id  ${tender.data}  ${doc_id}
  Log  ${document}
  [Return]  ${document['${field_name}']}


Отримати документ до скасування
  [Arguments]  ${username}  ${tender_uaid}  ${cancel_id}  ${doc_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${document}=  get_document_by_id  ${tender.data}  ${doc_id}
  ${filename}=  download_file_from_url  ${document.url}  ${OUTPUT_DIR}${/}${document.title}
  [return]  ${filename}


Скасувати план
  [Arguments]  ${username}  ${tender_uaid}  ${cancellation_reason}
  ${tender}=  openprocurement_client.Пошук плану по ідентифікатору  ${username}  ${tender_uaid}
  ${data}=  Create dictionary  cancellation=${cancellation_reason}
  ${cancellation_data}=  Create dictionary  data=${data}
  ${cancellation_data}=  munch_dict  arg=${cancellation_data}
  ${cancel_reply}=  Call Method  ${USERS.users['${username}'].plan_client}  patch_plan
  ...      ${tender.data.id}
  ...      ${cancellation_data}
  ...      access_token=${tender.access.token}
  ${cancellation_id}=  Set variable  ${cancel_reply.data.id}
  openprocurement_client.Підтвердити скасування плану  ${username}  ${tender_uaid}  ${cancellation_id}


Підтвердити скасування плану
  [Documentation]
  ...      [Arguments] Username, tender uaid
  ...      Find plan using uaid, get cancellation test_confirmation data and call patch_plan
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${cancellation_id}
  ${tender}=  openprocurement_client.Пошук плану по ідентифікатору  ${username}  ${tender_uaid}
  ${data}=  test_confirm_plan_cancel_data
  Log  ${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].plan_client}  patch_plan
  ...      ${tender.data.id}
  ...      ${data}
  ...      access_token=${tender.access.token}
  Log  ${reply}

##############################################################################
#             OpenUA procedure
##############################################################################

Підтвердити кваліфікацію
  [Documentation]
  ...      [Arguments] Username, tender uaid and qualification number
  ...      [Description] Find tender using uaid, create data dict with active status and call patch_qualification
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${tender_uaid}  ${qualification_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${qualification}=  create_data_dict   data.status  active
  Set To Dictionary  ${qualification.data}  id=${tender.data.qualifications[${qualification_num}].id}  eligible=${True}  qualified=${True}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_qualification
  ...      ${tender.data.id}
  ...      ${qualification}
  ...      ${qualification.data.id}
  ...      access_token=${tender.access.token}
  Log  ${reply}


Відхилити кваліфікацію
  [Documentation]
  ...      [Arguments] Username, tender uaid and qualification number
  ...      [Description] Find tender using uaid, create data dict with unsuccessful status and call patch_qualification
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${tender_uaid}  ${qualification_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${qualification}=  create_data_dict   data.status  unsuccessful
  Set To Dictionary  ${qualification.data}  id=${tender.data.qualifications[${qualification_num}].id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_qualification
  ...      ${tender.data.id}
  ...      ${qualification}
  ...      ${qualification.data.id}
  ...      access_token=${tender.access.token}
  Log  ${reply}


Завантажити документ у кваліфікацію
  [Documentation]
  ...      [Arguments] Username, tender uaid, qualification number and document to upload
  ...      [Description] Find tender using uaid,  and call upload_qualification_document
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${document}  ${tender_uaid}  ${qualification_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${doc_reply}=  Call Method  ${USERS.users['${username}'].client}  upload_qualification_document
  ...      ${document}
  ...      ${tender.data.id}
  ...      ${tender.data.qualifications[${qualification_num}].id}
  ...      access_token=${tender.access.token}
  Log  ${doc_reply}


Скасувати кваліфікацію
  [Documentation]
  ...      [Arguments] Username, tender uaid and qualification number
  ...      [Description] Find tender using uaid, create data dict with cancelled status and call patch_qualification
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${tender_uaid}  ${qualification_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${qualification}=  create_data_dict   data.status  cancelled
  Set To Dictionary  ${qualification.data}  id=${tender.data.qualifications[${qualification_num}].id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_qualification
  ...      ${tender.data.id}
  ...      ${qualification}
  ...      ${qualification.data.id}
  ...      access_token=${tender.access.token}
  Log  ${reply}


Затвердити остаточне рішення кваліфікації
  [Documentation]
  ...      [Arguments] Username and tender uaid
  ...
  ...      [Description] Find tender using uaid and call patch_tender
  ...
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${tender_uaid}
  ${internal_id}=  openprocurement_client.Отримати internal id по UAid  ${username}  ${tender_uaid}
  ${tender}=  create_data_dict  data.id  ${internal_id}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  set_to_object  ${tender}  data.status  active.pre-qualification.stand-still
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_tender
  ...      ${tender.data.id}
  ...      ${tender}
  ...      access_token=${tender.access.token}
  Log  ${reply}


Затвердити постачальників
  [Arguments]  ${username}  ${tender_uaid}
  ${internal_id}=  openprocurement_client.Отримати internal id по UAid  ${username}  ${tender_uaid}
  ${tender}=  create_data_dict  data.id  ${internal_id}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  set_to_object  ${tender}  data.status  active.qualification.stand-still
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_tender
  ...      ${tender.data.id}
  ...      ${tender}
  ...      access_token=${tender.access.token}
  Log  ${reply}


Перевести тендер на статус очікування обробки мостом
  [Documentation]
  ...      [Arguments] Username and tender uaid
  ...
  ...      [Description] Find tender using uaid and call patch_tender
  ...
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${tender_uaid}
  ${internal_id}=  openprocurement_client.Отримати internal id по UAid  ${username}  ${tender_uaid}
  ${tender}=  create_data_dict  data.id  ${internal_id}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  set_to_object  ${tender}  data.status  active.stage2.waiting
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_tender
  ...      ${tender.data.id}
  ...      ${tender}
  ...      access_token=${tender.access.token}
  Log  ${reply}


Активувати другий етап
  [Documentation]
  ...      [Arguments] Username and tender uaid
  ...
  ...      [Description] Find tender using uaid and call patch_tender
  ...
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${tender_uaid}
  ${internal_id}=  openprocurement_client.Отримати internal id по UAid  ${username}  ${tender_uaid}
  ${tender}=  create_data_dict  data.id  ${internal_id}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  set_to_object  ${tender}  data.status  active.tendering
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_tender
  ...      ${tender.data.id}
  ...      ${tender}
  ...      access_token=${tender.access.token}
  Log  ${reply}

##############################################################################
#             CONTRACT SIGNING
##############################################################################

Редагувати угоду
  [Arguments]  ${username}  ${tender_uaid}  ${contract_index}  ${fieldname}  ${fieldvalue}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${contract}=  Create Dictionary  data=${tender.data.contracts[${contract_index}]}
  Set_to_object  ${contract.data}  ${fieldname}  ${fieldvalue}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_contract
  ...      ${tender.data.id}
  ...      ${contract}
  ...      ${contract.data.id}
  ...      access_token=${tender.access.token}
  Log  ${reply}


Редагувати обидва поля вартості угоди
  [Arguments]  ${username}  ${tender_uaid}  ${contract_index}  ${field_amount}  ${field_amountNet}  ${fieldvalue}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${contract}=  Create Dictionary  data=${tender.data.contracts[${contract_index}]}
  Set_to_object  ${contract.data}  ${field_amount}  ${fieldvalue}
  Set_to_object  ${contract.data}  ${field_amountNet}  ${fieldvalue}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_contract
  ...      ${tender.data.id}
  ...      ${contract}
  ...      ${contract.data.id}
  ...      access_token=${tender.access.token}
  Log  ${reply}


Змінити ознаку ПДВ на True
  [Arguments]  ${username}  ${tender_uaid}  ${contract_index}  ${vat_fieldvalue}  ${field_amount}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${contract}=  Create Dictionary  data=${tender.data.contracts[${contract_index}]}
  Set To Dictionary  ${contract.data.value}  valueAddedTaxIncluded=${vat_fieldvalue}
  Set To Dictionary  ${contract.data.value}  amountNet=${field_amount}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_contract
  ...      ${tender.data.id}
  ...      ${contract}
  ...      ${contract.data.id}
  ...      access_token=${tender.access.token}
  Log  ${reply}


Встановити ціну за одиницю для контракту
  [Arguments]  ${username}  ${tender_uaid}  ${contract_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Log  ${tender}
  Log  ${contract_data}
  ${tender_id}=  Set Variable  ${tender.data.id}
  ${agreement_id}=  Set Variable  ${tender.data.agreements[0].id}
  ${contract_id}=  Set Variable  ${contract_data.data.id}
  ${access_token}=  Set Variable  ${tender.access.token}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_agreement_contract
  ...      ${tender_id}
  ...      ${agreement_id}
  ...      ${contract_data}
  ...      contract_id=${contract_id}
  ...      access_token=${access_token}
  Log  ${reply}


Зареєструвати угоду
  [Arguments]  ${username}  ${tender_uaid}  ${period}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${agreement}=  Create Dictionary  data=${tender.data.agreements[0]}
  Set To Dictionary  ${agreement.data}  status=active
  Set To Dictionary  ${agreement.data}  period=${period}
  ${tender_id}=  Set Variable  ${tender.data.id}
  ${agreement_id}=  Set Variable  ${tender.data.agreements[0].id}
  ${access_token}=  Set Variable  ${tender.access.token}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_agreement
  ...      ${tender_id}
  ...      ${agreement}
  ...      ${agreement_id}
  ...      access_token=${access_token}
  Log  ${reply}


Змінити ознаку ПДВ
  [Arguments]  ${username}  ${tender_uaid}  ${contract_index}  ${fieldvalue}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${contract}=  Create Dictionary  data=${tender.data.contracts[${contract_index}]}
  Set To Dictionary  ${contract.data.value}  valueAddedTaxIncluded=${fieldvalue}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_contract
  ...      ${tender.data.id}
  ...      ${contract}
  ...      ${contract.data.id}
  ...      access_token=${tender.access.token}
  Log  ${reply}


Встановити дату підписання угоди
  [Arguments]  ${username}  ${tender_uaid}  ${contract_index}  ${fieldvalue}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${contract}=  Create Dictionary  data=${tender.data.contracts[${contract_index}]}
  Set To Dictionary  ${contract.data}  dateSigned=${fieldvalue}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_contract
  ...      ${tender.data.id}
  ...      ${contract}
  ...      ${contract.data.id}
  ...      access_token=${tender.access.token}
  Log  ${reply}


Вказати період дії угоди
  [Arguments]  ${username}  ${tender_uaid}  ${contract_index}  ${startDate}  ${endDate}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${period}=  Create Dictionary  startDate=${startDate}
  Set to Dictionary  ${period}  endDate=${endDate}
  ${contract}=  Create Dictionary  data=${tender.data.contracts[${contract_index}]}
  Set To Dictionary  ${contract.data}  period=${period}
  Log  ${contract}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_contract
  ...      ${tender.data.id}
  ...      ${contract}
  ...      ${contract.data.id}
  ...      access_token=${tender.access.token}
  Log  ${reply}


Завантажити документ в угоду
  [Arguments]  ${username}  ${path}  ${tender_uaid}  ${contract_index}  ${doc_type}=documents
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${contract_id}=  Get Variable Value  ${tender.data.contracts[${contract_index}].id}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}']['access_token']}
  ${response}=  Call Method  ${USERS.users['${username}'].client}  upload_contract_document
  ...      ${path}
  ...      ${tender.data.id}
  ...      ${contract_id}
  ...      access_token=${tender.access.token}
  ${uploaded_file} =  Create Dictionary
  ...      filepath=${path}
  ...      upload_response=${response}
  Log object data  ${uploaded_file}


Підтвердити підписання контракту
  [Documentation]
  ...      [Arguments] Username, tender uaid, contract number
  ...      Find tender using uaid, get contract test_confirmation data and call patch_contract
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${contract_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${data}=  test_confirm_data  ${tender['data']['contracts'][${contract_num}]['id']}
  Log  ${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_contract
  ...      ${tender.data.id}
  ...      ${data}
  ...      ${data.data.id}
  ...      access_token=${tender.access.token}
  Log  ${reply}
  [Return]  ${reply}

##############################################################################
#             CONTRACT MANAGEMENT
##############################################################################

Отримати internal id по UAid для договору
  [Arguments]  ${username}  ${contract_uaid}
  Log  ${contract_uaid}
  Log  ${USERS.users['${username}'].contracts_id_map}
  ${status}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${USERS.users['${username}'].contracts_id_map}  ${contract_uaid}
  Run Keyword and Return If  ${status}  Get From Dictionary  ${USERS.users['${username}'].contracts_id_map}  ${contract_uaid}
  Call Method  ${USERS.users['${username}'].contracting_client}  get_contracts
  ${contract_id}=  Wait Until Keyword Succeeds  15x  10 sec  get_contract_id_by_uaid  ${contract_uaid}  ${USERS.users['${username}'].contracting_client}
  Set To Dictionary  ${USERS.users['${username}'].contracts_id_map}  ${contract_uaid}  ${contract_id}
  [Return]  ${contract_id}


Оновити сторінку з договором
  [Arguments]  ${username}  ${contract_uaid}
  openprocurement_client.Пошук договору по ідентифікатору  ${username}  ${contract_uaid}


Отримати список договорів
  [Arguments]  ${username}
  @{contracts_feed}=  get_contracts_feed  ${USERS.users['${username}'].contracting_client}
  [return]  @{contracts_feed}


Отримати договір по внутрішньому ідентифікатору
  [Arguments]  ${username}  ${internalid}
  ${contract}=  Call Method  ${USERS.users['${username}'].contracting_client}  get_contract  ${internalid}
  ${contract}=  munch_dict  arg=${contract}
  Set To Dictionary  ${USERS.users['${username}']}  contract_data=${contract}
  Log  ${contract}
  [return]  ${contract}


Пошук договору по ідентифікатору
  [Arguments]  ${username}  ${contract_uaid}
  ${internalid}=  openprocurement_client.Отримати internal id по UAid для договору  ${username}  ${contract_uaid}
  ${contract}=  openprocurement_client.Отримати договір по внутрішньому ідентифікатору  ${username}  ${internalid}
  [return]  ${contract}


Отримати доступ до договору
  [Arguments]  ${username}  ${contract_uaid}
  ${internalid}=  openprocurement_client.Отримати internal id по UAid для договору  ${username}  ${contract_uaid}
  ${contract}=  Call Method  ${USERS.users['${username}'].contracting_client}  retrieve_contract_credentials  ${internalid}  ${USERS.users['${username}'].access_token}
  ${contract}=  munch_dict  arg=${contract}
  Set To Dictionary  ${USERS.users['${username}']}  contract_data=${contract}
  Set To Dictionary  ${USERS.users['${username}']}  contract_access_token=${contract.access.token}
  Log  ${contract}
  [return]  ${contract}


Внести зміну в договір
  [Arguments]  ${username}  ${contract_uaid}  ${change_data}
  ${internalid}=  openprocurement_client.Отримати internal id по UAid для договору  ${username}  ${contract_uaid}
  ${reply}=  Call Method  ${USERS.users['${username}'].contracting_client}  create_change  ${internalid}  ${USERS.users['${username}'].contract_access_token}  ${change_data}
  # we need this to have change id in `Додати документацію до зміни в договорі` and `Застосувати зміну` keywords
  ${empty_list}=  Create List
  ${changes}=  Get variable value  ${USERS.users['${username}'].changes}  ${empty_list}
  Append to list  ${changes}  ${reply}
  Set to dictionary  ${USERS.users['${username}']}  changes=${changes}
  Log  ${change_data}
  Log  ${reply}


Додати документацію до зміни в договорі
  [Arguments]  ${username}  ${contract_uaid}  ${document}
  ${contract}=  openprocurement_client.Пошук договору по ідентифікатору  ${username}  ${contract_uaid}
  ${contract}=  set_access_key  ${contract}  ${USERS.users['${username}'].contract_access_token}
  ${reply_doc_create}=  Call Method  ${USERS.users['${username}'].contracting_client}  upload_document
  ...      ${document}
  ...      ${contract.data.id}
  ...      access_token=${contract.access.token}
  ${change_document}=  test_change_document_data  ${reply_doc_create}  ${USERS.users['${username}'].changes[0].data.id}
  ${reply_doc_patch}=  Call Method  ${USERS.users['${username}'].contracting_client}  patch_document
  ...      ${contract.data.id}
  ...      ${change_document}
  ...      ${change_document.data.id}
  ...      access_token=${contract.access.token}
  Log  ${reply_doc_create}
  Log  ${reply_doc_patch}


Редагувати поле договору
  [Arguments]  ${username}  ${contract_uaid}  ${fieldname}  ${fieldvalue}
  ${internalid}=  openprocurement_client.Отримати internal id по UAid для договору  ${username}  ${contract_uaid}
  ${contract}=  openprocurement_client.Пошук договору по ідентифікатору  ${username}  ${contract_uaid}
  Set_To_Object  ${contract.data}   ${fieldname}   ${fieldvalue}
  Log  ${contract}
  ${contract}=  Call Method  ${USERS.users['${username}'].contracting_client}  patch_contract  ${internalid}  ${USERS.users['${username}'].contract_access_token}  ${contract}
  Log  ${contract}


Одночасно Редагувати два поля договору
  [Arguments]  ${username}  ${contract_uaid}  ${first_fieldname}  ${first_fieldvalue}  ${second_fieldname}  ${second_fieldvalue}
  ${internalid}=  openprocurement_client.Отримати internal id по UAid для договору  ${username}  ${contract_uaid}
  ${contract}=  openprocurement_client.Пошук договору по ідентифікатору  ${username}  ${contract_uaid}
  Set_To_Object  ${contract.data}  ${first_fieldname}  ${first_fieldvalue}
  Set_To_Object  ${contract.data}  ${second_fieldname}  ${second_fieldvalue}
  Log  ${contract}
  ${contract}=  Call Method  ${USERS.users['${username}'].contracting_client}  patch_contract  ${internalid}  ${USERS.users['${username}'].contract_access_token}  ${contract}
  Log  ${contract}


Редагувати зміну
  [Arguments]  ${username}  ${contract_uaid}  ${fieldname}  ${fieldvalue}
  ${internalid}=  openprocurement_client.Отримати internal id по UAid для договору  ${username}  ${contract_uaid}
  ${data}=  Create Dictionary  ${fieldname}=${fieldvalue}
  ${data}=  Create Dictionary  data=${data}
  ${changes}=  Get variable value  ${USERS.users['${username}'].changes}
  ${change}=  munchify  ${changes[-1]}
  Log  ${change}
  ${reply}=  Call Method  ${USERS.users['${username}'].contracting_client}  patch_change  ${internalid}  ${USERS.users['${username}'].changes[-1].data.id}  ${USERS.users['${username}'].contract_access_token}  ${data}
  Log  ${data}
  Log  ${reply}


Застосувати зміну
  [Arguments]  ${username}  ${contract_uaid}  ${dateSigned}
  ${internalid}=  openprocurement_client.Отримати internal id по UAid для договору  ${username}  ${contract_uaid}
  ${data}=  Create Dictionary  status=active  dateSigned=${dateSigned}
  ${data}=  Create Dictionary  data=${data}
  ${changes}=  Get variable value  ${USERS.users['${username}'].changes}
  ${change}=  munchify  ${changes[-1]}
  Log  ${change}
  ${reply}=  Call Method  ${USERS.users['${username}'].contracting_client}  patch_change  ${internalid}  ${USERS.users['${username}'].changes[-1].data.id}  ${USERS.users['${username}'].contract_access_token}  ${data}
  Log  ${data}
  Log  ${reply}


Завантажити документацію до договору
  [Arguments]  ${username}  ${contract_uaid}  ${document}
  ${contract}=  openprocurement_client.Пошук договору по ідентифікатору  ${username}  ${contract_uaid}
  ${contract}=  set_access_key  ${contract}  ${USERS.users['${username}'].contract_access_token}
  ${reply}=  Call Method  ${USERS.users['${username}'].contracting_client}  upload_document
  ...      ${document}
  ...      ${contract.data.id}
  ...      access_token=${contract.access.token}
  Log  ${reply}


Внести зміни в договір
  [Arguments]  ${username}  ${contract_uaid}  ${data}
  ${internalid}=  openprocurement_client.Отримати internal id по UAid для договору  ${username}  ${contract_uaid}
  ${reply}=  Call Method  ${USERS.users['${username}'].contracting_client}  patch_contract  ${internalid}  ${USERS.users['${username}'].contract_access_token}  ${data}
  Log  ${reply}


Завершити договір
  [Arguments]  ${username}  ${contract_uaid}
  ${internalid}=  openprocurement_client.Отримати internal id по UAid для договору  ${username}  ${contract_uaid}
  ${data}=  Create Dictionary  status=terminated
  ${data}=  Create Dictionary  data=${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].contracting_client}  patch_contract  ${internalid}  ${USERS.users['${username}'].contract_access_token}  ${data}


Отримати інформацію із договору
  [Arguments]  ${username}  ${contract_uaid}  ${field_name}
  openprocurement_client.Пошук договору по ідентифікатору
  ...      ${username}
  ...      ${contract_uaid}

  ${status}  ${field_value}=  Run keyword and ignore error
  ...      Get from object
  ...      ${USERS.users['${username}'].contract_data.data}
  ...      ${field_name}
  Run Keyword if  '${status}' == 'PASS'  Return from keyword   ${field_value}

  Fail  Field not found: ${field_name}


Отримати інформацію із документа до договору
  [Arguments]  ${username}  ${contract_uaid}  ${doc_id}  ${field_name}
  ${tender}=  openprocurement_client.Пошук договору по ідентифікатору  ${username}  ${contract_uaid}
  ${document}=  get_document_by_id  ${tender.data}  ${doc_id}
  Log  ${document}
  [Return]  ${document['${field_name}']}


Отримати документ до договору
  [Arguments]  ${username}  ${contract_uaid}  ${doc_id}
  ${tender}=  openprocurement_client.Пошук договору по ідентифікатору  ${username}  ${contract_uaid}
  ${document}=  get_document_by_id  ${tender.data}  ${doc_id}
  ${filename}=  download_file_from_url  ${document.url}  ${OUTPUT_DIR}${/}${document.title}
  [return]  ${filename}


Отримати доступ до угоди
  [Arguments]  ${username}  ${agreement_uaid}
  ${token}=  Set Variable  ${USERS.users['${username}'].access_token}
  ${internalid}=  openprocurement_client.Отримати internal id угоди по UAid  ${username}  ${agreement_uaid}
  ${agreement}=  Call Method  ${USERS.users['${username}'].agreement_client}  patch_credentials  ${internalid}  ${token}
  Set To Dictionary  ${USERS.users['${username}']}  agreement_access_token=${agreement.access.token}
  ${agreement}=  munch_dict  arg=${agreement}
  [return]   ${agreement}


Внести зміну в угоду
  [Arguments]  ${username}  ${agreement_uaid}  ${change_data}
  ${internalid}=  openprocurement_client.Отримати internal id угоди по UAid  ${username}  ${agreement_uaid}
  ${reply}=  Call Method  ${USERS.users['${username}'].agreement_client}  create_change
  ...      ${internalid}
  ...      ${change_data}
  ...      access_token=${USERS.users['${username}'].agreement_access_token}
  Log  ${reply}


Застосувати зміну для угоди
  [Arguments]  ${username}  ${agreement_uaid}  ${dateSigned}  ${status}
  ${agreement}=  openprocurement_client.Пошук угоди по ідентифікатору  ${username}  ${agreement_uaid}
  ${data}=  Create Dictionary  status=${status}  dateSigned=${dateSigned}
  ${data}=  Create Dictionary  data=${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].agreement_client}  patch_change
  ...      ${agreement.data.id}
  ...      ${data}
  ...      ${agreement.data.changes[-1].id}
  ...      access_token=${USERS.users['${username}'].agreement_access_token}
  Log  ${reply}


Оновити властивості угоди
  [Arguments]  ${username}  ${agreement_uaid}  ${data}
  ${agreement}=  openprocurement_client.Пошук угоди по ідентифікатору  ${username}  ${agreement_uaid}
  ${reply}=  Call Method  ${USERS.users['${username}'].agreement_client}  patch_change
  ...      ${agreement.data.id}
  ...      ${data}
  ...      ${agreement.data.changes[-1].id}
  ...      access_token=${USERS.users['${username}'].agreement_access_token}
  Log  ${reply}


Завантажити документ в рамкову угоду
  [Arguments]  ${username}  ${filepath}  ${agreement_uaid}
  Log  ${username}
  Log  ${agreement_uaid}
  Log  ${filepath}
  ${agreement}=  openprocurement_client.Пошук угоди по ідентифікатору  ${username}  ${agreement_uaid}
  ${reply}=  Call Method  ${USERS.users['${username}'].agreement_client}  upload_document
  ...      ${filepath}
  ...      ${agreement.data.id}
  ...      access_token=${USERS.users['${username}'].agreement_access_token}
  Log Object Data  ${reply}  reply
  [return]  ${reply}


Завантажити документ для зміни у рамковій угоді
  [Arguments]  ${username}  ${filepath}  ${agreement_uaid}  ${item_id}
  Log  ${username}
  Log  ${agreement_uaid}
  Log  ${filepath}
  ${agreement}=  openprocurement_client.Пошук угоди по ідентифікатору  ${username}  ${agreement_uaid}
  ${document}=  openprocurement_client.Завантажити документ в рамкову угоду  ${username}  ${filepath}  ${agreement_uaid}
  Set to dictionary  ${document.data}  documentOf=change
  Set to dictionary  ${document.data}  relatedItem=${item_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].agreement_client}  patch_document
  ...      ${agreement.data.id}
  ...      ${document}
  ...      ${document.data.id}
  ...      access_token=${USERS.users['${username}'].agreement_access_token}
  [return]  ${reply}


Завершити угоду
  [Arguments]  ${username}  ${agreement_uaid}
  ${internalid}=  openprocurement_client.Отримати internal id угоди по UAid  ${username}  ${agreement_uaid}
  ${data}=  Create Dictionary  status=terminated
  ${data}=  Create Dictionary  data=${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].agreement_client}  patch_agreement
  ...      ${internalid}
  ...      ${data}
  ...      access_token=${USERS.users['${username}'].agreement_access_token}


Отримати інформацію із угоди
  [Arguments]  ${username}  ${agreement_uaid}  ${field_name}
  openprocurement_client.Пошук угоди по ідентифікатору
  ...      ${username}
  ...      ${agreement_uaid}
  ${status}  ${field_value}=  Run Keyword And Ignore Error
  ...      Get From Object
  ...      ${USERS.users['${username}'].agreement_data.data}
  ...      ${field_name}
  Run Keyword If  '${status}' == 'PASS'  Return From Keyword   ${field_value}
  Fail  Field not found: ${field_name}


знайти план за ідентифікатором
  [Arguments]  ${tender_uaid}  ${username}  ${save_key}=tender_data
  ${internalid}=  openprocurement_client.Отримати internal id плану по UAid  ${username}  ${tender_uaid}
  ${plan}=  openprocurement_client.Отримати план по внутрішньому ідентифікатору  ${username}  ${internalid}  ${save_key}
  [return]  ${plan}