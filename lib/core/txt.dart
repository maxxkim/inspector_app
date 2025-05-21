import 'package:inspector_tps/core/api/endpoints.dart';

abstract class Txt {
  static const appName = 'TPS';

// auth
  static const tps = 'ТПС';
  static const estate = 'Недвижимость';
  static const enter = 'Войти';
  static const logout = 'Выйти из аккаунта';
  static const login = 'Логин';
  static const pwd = 'Пароль';
  static const groups = 'Группы пользователя:';

// tabs
  static const tabAudit = 'Аудиты';
  static String audits = 'Список аудитов';
  static const tabProfile = 'Профиль';
  static const tabClaims = 'Заявки';
  static const tabTo = 'ППР';

// errors
  static const somethingWentWrong = 'Что-то пошло не так, попробуйте еще раз';
  static const unauthorizedMessage = 'Не верный логин или пароль';
  static const close = 'Закрыть';
  static const errorTitle = 'Ошибка';
  static const offline = 'Устройство не подключено к интернету,\n'
      'повторите оперцию при наличие соединения';
  static var locallySaved = 'Статус не передан в Максимо';

  // ppr
  static String pprs = 'Список ППР';
  static String noPpr = 'Нет загруженных ППР';
  static String noPprForShift = 'ППР на текущую смену отсутствуют';
  static String downloadPprMonth = 'Загрузить список ППР';
  static String downloadPprWeek = 'Загрузить ППР за неделю';
  static String downloadPprWorkShift = 'Загрузить ППР за смену (сутки и новые)';
  static String updatePprList = 'Добавить утвержденные ППР из Максимо';
  static String clearPprList = 'Удалить все загруженные ППР';
  static String clearCompletedPpr = 'Удалить завершенные ППР';
  static String currentShift = 'Текущая смена';
  static String outdated = 'Просроченные';
  static String allPpr = 'Всe загруженные ППР';
  static String completedPpr = 'Завершенные ППР';
  static String plannedJob = 'Плановая работа';
  static String statusCond = 'Состояние';
  static String fromWho = 'От кого';
  static String priority = 'Приоритет';
  static String systemCategory = 'Квтегория системы';
  static String plannedStart = 'Плановое начало';
  static String plannedFinish = 'Плановое окончание';
  static String assetDescription = 'Объект эксплуатации';
  static String assetLocation = 'Местоположение';
  static String takeInWork = 'Взять в работу';
  static String sendForApprovalZde = "Отправить на согласование ЗДЭ";
  static String reportEquipmentFailure =
      'Сообщить о неработоспособности оборудования';
  static String registerToDescription =
      '\u002A Для регистрации внепланового ТО требуется выполнить действие в веб-версии системы';
  static var completePprDescription =
      'Для завершения работы требуется указать статус всех операций.\n\n'
      'Для операций со статусом "Неудовлетворительно" требуется заполнить комментарий.';
  static String sendReadyPpr = 'Передать готовые ППР в Максимо';
  static String addCommentToAttachedPhoto =
      'Добавьте комментарий для приложенных снимков';
  static String sendPhotoWithComment = "Отправить";
  static String sendChanges = "Отправить изменения";

  // claims

  static String rzList = 'Все РЗ';
  static String rzs = 'Рабочие задания';
  static String rz = 'РЗ';
  static String claims = 'Заявки';
  static String noRz = 'Нет загруженных РЗ';
  static String noRzForShift = 'РЗ на текущую смену отсутствуют';
  static String downloadRz = 'Загрузить список РЗ';
  static String newClaim = 'Новая заявка';
  static String pickSite = 'Площадка:';
  static String create = 'Создать';
  static String createNewClaim = 'Создать новую заявку';
  static String saveNewClaim = 'Сохранить';
  static String enterLocation = 'Заполните местопложение';
  static String enterDescription = 'Заполните описание';
  static String locationDescription = 'Описание местоположения';
  static String claimText = 'Текст заявки';
  static String sentClaims = 'Отправленные заявки';
  static String savedClaims = 'Сохраненные заявки';
  static String sendSavedClaims = 'Отправить сохраненные заявки';
  static String sendSavedRz = 'Передать готовые РЗ в Максимо';
  static String addRzComment = 'Добавить комментарий';
  static String claimFrom = 'Заявка от: ';
  static String renewAssets = 'Обновить справочник объектов эксплуатации';
  static String downloadSites = 'Загрузить площадки';
  static String downloadAssets = 'Загрузить справочник объектов эксплуатации';
  static String assets = 'Справочник объектов эксплуатации';
  static String asset = 'Объект эксплуатации';
  static String claim = 'Заявка';
  static String pickAsset = 'Выбрать объект эксплуатации';
  static String searchAsset = 'Поиск объекта эксплуатации';
  static String assetsCount = 'Всего объектов:';
  static String clearRzList = 'Удалить все загруженные РЗ';
  static String clearPreApprovedRz = 'Удалить обработанные РЗ';
  static String shouldAddCommentButton = 'Необходимо добавить комментарий';
  static String deleteClaimDialogTitle = 'Удаление заявки';
  static String deleteClaimDialogContent = 'Заявка будет удалена с устройства!';

// audits
  static String factorValue = 'Значение фактора';
  static String noAudits = 'Нет загруженных аудитов';
  static String downloadAudits = 'Загрузить аудиты из Maximo';
  static String downloadChecklist = 'Загрузить чек-лист аудита';
  static String downloadDescription =
      'Чек-лист данного аудита не был загружен на устройство.';
  static String downloadDescription2 =
      '(Для загрузки необходимо устойчивое подключение к интернету.)';

  static String deleteAudit = 'Удалить аудит с устройства';
  static String sendAuditToMaximo =
      'Передать результат прохождения аудита в Максимо';
  static String updateAuditsList = 'Добавить сформированные аудиты из Максимо';
  static String deleteAuditDialogTitle = 'Удаление аудита';
  static String deleteRsDefectCommentDialogTitle = 'Удаление комментария';
  static String changeContourDialogTitle = 'Сменить контур';
  static String sendingAuditToMaximoDialogTitle = 'Отправка аудита в Максимо';

  static String teReportData = 'Данные отчета ТЭ';

  static String changeAddress = 'Сменить адрес';

  static String internetNeededForDataSending =
      'Требуется наличие надежного интернет соединения для отправки данных на сервер';

  static String internetNeededForDataLoading =
      'Требуется наличие надежного интернет соединения для загрузки данных';

  static String sentAuditToMaximoResultDialogContent(
          int count, String wonum, int total) =>
      'Аудит: $wonum\n'
      'Всего к отправке: $total\n'
      'Обновлено пунктов чек-листа: $count';

  static String checklistBack = 'Назад';
  static String status = 'Статус';
  static String comment = 'Комментарий';
  static String downloadedComments = 'Загруженные комментарии';
  static String myComments = 'Мои комментарии';
  static String changeComment = 'Изменить комментарий';
  static String addComment = 'Добавить комментарий';
  static String shouldAddComment = 'Добавьте комментарий';
  static String editCommentDialogTitle = 'Редактирование комментария';
  static String save = 'Сохранить';

  static String ok = 'Ок';
  static String deletePhoto = 'Удалить фото';

  static String deleteAuditDialogContent(String name) =>
      'Аудит $name\nбудет удален с устройства.\n\n'
      'Данные не переданные в Maximo будут утеряны.\n\n'
      'Вы уверены, что аудит пройден или больше не нужен на устройстве?';

  // buttons
  static String cancel = 'Отмена';
  static String closeMenu = 'Закрыть меню';
  static String delete = 'Удалить';

  static String tech = 'Техническая эксплуатация';

  static String setProd = 'Установить рабочий контур';
  static String setDev = 'Установить контур разработки';

  static String addPprComment = 'Добавить комментарий к ППР';

  static String downloaded = 'Загруженные комментарии';
  static String fresh = 'Новые комментарии';

  static var allOperationsCompleted = 'Все операции выполнены';
  static var finish = 'Завершить';

  static String pprCompleted = 'ППР завершен';

  static String doNotCloseSendingPpr = 'Не закрывайте вкладку и приложение!\n'
      'Идёт обмен данными...';

  static var estDur = 'минут на выполнение:';

  static String confirm = 'Подтвердить выполнение';
  static String reject = 'Отклонить';
  static String rejectPpr = 'Отклонить ППР';

  static String report = "Сообщить";

  static var version = 'Версия:';

  static String takeAPicture = 'Сделайте фото';

  static String finishUntil = 'Выполнить до: ';

  static String from = 'От:';
  static String download = 'Загрузить';

  static String solved = 'Устранено';
  static String unSolved = 'Не устранено';
}

String changeContourDialogDescription(bool isDev) {
  final url = getHost;
  return isDev
      ? 'Контур разработки\n$url'
      : 'Рабочий контур\n(Production)\n$url';
}
