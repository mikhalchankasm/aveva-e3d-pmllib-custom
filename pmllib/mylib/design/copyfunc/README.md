# COPYCE

Русская версия | [English version](README.en.md)

`COPYCE` - это PML helper для копирования текущего элемента базы данных с последующим переименованием скопированных именованных элементов.

Идея простая: обычная команда `NEW ... COPY ...` делает техническую копию, но имена внутри дерева часто остаются неудобными для дальнейшей работы. Эта функция делает копию "человеческими руками": создает копию, подбирает свободный префикс, переименовывает корень и вложенные именованные элементы, а также создает `MARKDB`, чтобы операцию можно было откатить через `UNDODB`.

## Где лежит

```text
pmllib\mylib\design\copyfunc
```

Основной объект:

```text
copyce.pmlobj
```

## Простая копия

Если нужна обычная копия текущего `CE` под тем же владельцем, используйте короткую функцию:

```pml
!newCopy = !!copyCeWithCopyofNames(!!ce, !!ce.owner)
```

Она создаст копию и переименует элементы в стиле:

```text
/copyof-OriginalName
/copyof-(2)-OriginalName
```

Если копируется уже созданная копия, старый `copyof-` или `copyof-(n)-` из базового имени убирается. Поэтому повторные копии не превращаются в `copyof-copyof-...`; вместо этого меняется индекс:

```text
/copyof-OriginalName
/copyof-(2)-OriginalName
/copyof-(10)-OriginalName
```

Второй вариант - напрямую через объект:

```pml
!copy = object COPYCE(!!ce, !!ce.owner)
!newCopy = !copy.run()
```

После запуска можно посмотреть результат:

```pml
q var !copy.copyRoot
q var !copy.lastPrefix
q var !copy.lastRenamed
```

## Копия со своим префиксом

Если нужно не `copyof`, а свой префикс, например `clone`, используйте:

```pml
!newCopy = !!copyCeWithPrefixRoot(!!ce, !!ce.owner, 'clone')
```

Примеры имен:

```text
/clone-PipeName
/clone-BranchName
/clone-(2)-PipeName
```

Если нужно задать текст undo-метки:

```pml
!newCopy = !!copyCeWithPrefixRootMark(!!ce, !!ce.owner, 'clone', 'Clone current CE')
```

## Ограничение длины имени

Полное имя элемента, включая `/`, ограничено 50 символами. `COPYCE` строит имя с учетом текущего префикса и индекса копии. Если имя получается слишком длинным, обрезается базовая часть имени, а префикс и индекс сохраняются.

Например, для десятой копии место резервируется под `copyof-(10)-`, и уже после этого берется доступная часть исходного имени:

```text
/copyof-(10)-VeryLongOriginalElementName...
```

Если префикс сам по себе слишком длинный и под базовое имя не остается ни одного символа, такой вариант считается недоступным и копия не запускается с этим префиксом.

## Сложная или кастомная копия

Если нужна более сложная логика именования, создавайте объект `COPYCE` напрямую и задавайте режим:

```pml
!copy = object COPYCE(!!ce, !!ce.owner, 'typecopy', 'Copy TYPEPREFIX', 'TYPEPREFIX')
!newCopy = !copy.run()
```

Или используйте wrapper:

```pml
!newCopy = !!copyCeWithMode(!!ce, !!ce.owner, 'typecopy', 'TYPEPREFIX', 'Copy TYPEPREFIX')
```

Доступные режимы:

```text
DEFAULT     /copyof-PipeName
TYPEPREFIX  /typecopy-PIPE-PipeName
PIPEBRANCH  /pbcopy-P-PipeName or /pbcopy-B-BranchName
LOWER       /lowercopy-pipename
```

Смысл режимов:

- `DEFAULT` - универсальный режим. К имени добавляется только выбранный префикс, например `copyof-` или `clone-`. Подходит для обычной копии без дополнительной классификации.
- `TYPEPREFIX` - добавляет тип элемента после префикса: `PIPE`, `BRAN`, `EQUI` и т.д. Это удобно, когда в одной копируемой структуре есть разные типы элементов и их нужно различать уже по имени.
- `PIPEBRANCH` - специальный короткий режим для трубопроводов: `PIPE` получает метку `P-`, `BRAN` получает `B-`, остальные типы именуются как в `TYPEPREFIX`. Это уменьшает длину имени и оставляет понятную маркировку pipe/branch.
- `LOWER` - приводит итоговое имя к нижнему регистру. Используется, если в проекте принята lowercase-схема именования или нужно убрать смешанный регистр из копий.

## Примеры режимов

### DEFAULT

```pml
!copy = object COPYCE(!!ce, !!ce.owner, 'copyof', 'Copy DEFAULT', 'DEFAULT')
!newCopy = !copy.run()
```

### TYPEPREFIX

```pml
!copy = object COPYCE(!!ce, !!ce.owner, 'typecopy', 'Copy TYPEPREFIX', 'TYPEPREFIX')
!newCopy = !copy.run()
```

### PIPEBRANCH

```pml
!copy = object COPYCE(!!ce, !!ce.owner, 'pbcopy', 'Copy PIPEBRANCH', 'PIPEBRANCH')
!newCopy = !copy.run()
```

### LOWER

```pml
!copy = object COPYCE(!!ce, !!ce.owner, 'lowercopy', 'Copy LOWER', 'LOWER')
!newCopy = !copy.run()
```

## Тест

Запускать только на безопасном тестовом элементе:

```pml
!created = !!copyCeTestCurrent()
```

Тест создает четыре копии текущего `CE` под `CE.owner`:

```text
DEFAULT
TYPEPREFIX
PIPEBRANCH
LOWER
```

Откат:

```pml
UNDODB
UNDODB 4
```

## PostEvents

Опциональные callbacks для undo/redo:

```pml
!ok = !!copyCeInstallPostEvents()
```

Отключить вывод callbacks:

```pml
!ok = !!copyCePostEventsEnabled(FALSE)
```

Включить снова:

```pml
!ok = !!copyCePostEventsEnabled(TRUE)
```

## Файлы

```text
copyce.pmlobj                     основной объект COPYCE
copycepostevents.pmlobj           optional !!postEvents object
copyCeTestCurrent.pmlfnc          тестовый запуск
copyCeWithMode.pmlfnc             wrapper для режима именования
copyCeWithCopyofNames.pmlfnc      простая копия copyof
copyCeWithPrefixRoot.pmlfnc       копия со своим префиксом
copyCeWithPrefixRootMark.pmlfnc   копия со своим префиксом и MARKDB-текстом
```
