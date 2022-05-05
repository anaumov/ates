## Разбивка на актор, команду и данные

### Аутентификация и авторизация
актор — Popug  
команда — Popugs.LogIn  
данные — popugPublicId  
событие — Auth.LoggedIn? (скорее всего не нужно)

### Таск-трекер

#### Создать задачу
актор — Popug  
команда — Tasks.Create  
данные — description, popugPublicId  
события — Tasks.Created Tasks.Assigned (передаются ли данные в событие?)

#### Перемешать задачи  
актор — Popug с ролями admin, manager  
команда — Tasks.Reshuffle  
данные — нет  
событие — Tasks.Assigned

#### Закончить задачу  
актор — Popug  
команда — Tasks.Complete  
данные — popugPublicId, taskPublicId  
событие — Tasks.Completed

#### Посмотреть свои задачи
данные — popugPublicId, tasks_list    
актор — Popug с ролями admin, manager  
команда — Tasks.Show  
событие — ???

### Аккаунтинг

#### Добавить запись о движении по счету  
актор — команды Tasks.Assigned, Tasks.Completed, Accounting.PayoutDone  
команда — Accounting.AddTransaction  
данные — amount, popugPublicId, description, taskPublicId  
событие — Accounting.TransactionAdded

#### Обновить баланс счета  
актор — событие Accounting.TransactionAdded  
команда — Accounting.UpdateBalance  
данные — accountId, amount  
событие — Accounting.AccountUpdated

#### Выплатить вознаграждение  
актор — CRON ??? по расписанию  
команда — Accounting.MakePayout  
данные — accountId, amount, date  
событие — Accounting.PayoutDone

#### Отправить письмо с чеком  
актор — событие Accounting.PayoutDone  
команда — Accounting.SendReceipt  
данные — accountId, amount  
событие — Accounting.SentReceipt ???


### Посмотреть свой баланс и транзакции  
данные — account_balance, transactions_list  
актор — popug  
команда — Accounting.GetPopugAccount  
событие — ???

### Посмотреть прибыль топ менеджмента
данные — day_profit (Σassigned – Σcompleted)  
актор — popugAdmin  
команда — Accounting.GetManagmentIncome  
событие — ???

### Аналитика

#### Обновить сумму прибыли  
актор — событие Tasks.Assigned, Tasks.Completed  
команда — Analytics.UpdateProfit  
данные — amount, transactionTime  
событие — Analytics.ProfitUpdated

#### Обновить попугов в минусе  
актор — событие Tasks.Assigned, Tasks.Completed  
команда — Analytics.UpdateNegativePopugs
данные — amount, popugPublicId  
событие — Analytics.NegativePopugsUpdated

#### Обновить самую дорогую задачу  
актор — событие Tasks.Completed  
команда — Analytics.UpdateTopPricedTask
данные — amount
событие — Analytics.TopPricedTaskUpdated
