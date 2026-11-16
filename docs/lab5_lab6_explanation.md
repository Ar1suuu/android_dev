# Instagram clone: объяснение Lab 5 и Lab 6

Документ для защиты перед куратором. Технические термины оставлены на английском: **Dependency Injection**, **Provider**, **Notifier**, **state**, **rebuild**, **immutable**, **ConsumerWidget**, **ref.watch**, **ref.read**.

---

## 1. Что это за проект

Упрощённая копия Instagram на Flutter. В приложении есть:

- нижняя навигация из пяти вкладок;
- лента постов;
- горизонтальная лента stories;
- лайки постов и комментариев;
- кнопка сохранения поста;
- комментарии в bottom sheet;
- вкладка поиска с сеткой изображений и экраном деталей;
- загрузка данных о товарах через Dio с `dummyjson.com`.

Данные постов и stories хранятся локально в коде. Изображения тоже локальные, лежат в `assets/images/`. Сеть используется только на вкладке Search.

Проект развивался в два этапа:

- **Lab 5** — модели, данные, сервис, виджеты ленты и stories, навигация.
- **Lab 6** — Riverpod как state manager и Dependency Injection, immutable-модель, тесты.

---

## 2. Технологии и зависимости

`pubspec.yaml`:

```yaml
dependencies:
  dio: ^5.11.1
  flutter:
    sdk: flutter
  flutter_riverpod: ^3.5.0
  material_ui: ^1.11.0
```

- **flutter_riverpod** — state management и Dependency Injection.
- **dio** — HTTP-клиент для вкладки Search.
- **material_ui** — официальная Material-библиотека Flutter, вынесенная в отдельный пакет. Все экраны импортируют `package:material_ui/material_ui.dart` вместо `package:flutter/material.dart`, чтобы использовать одну и ту же версию Material-виджетов.
- **assets/images/** — локальные изображения, подключённые в `pubspec.yaml`.

---

## 3. Структура `lib/`

```text
lib/
├── main.dart
├── future_dart_example.dart
├── screens/
│   ├── main_screen.dart
│   ├── content_detail_screen.dart
│   ├── content/
│   │   └── post_widget.dart
│   ├── tabs/
│   │   ├── home_tab.dart
│   │   ├── search_tab.dart
│   │   └── placeholder_tab.dart
│   └── home_screen/
│       ├── data/
│       │   └── posts_data.dart
│       ├── models/
│       │   ├── post_model.dart
│       │   ├── story_model.dart
│       │   └── comment_model.dart
│       ├── providers/
│       │   └── post_providers.dart
│       ├── services/
│       │   ├── post_services.dart
│       │   └── dio_service.dart
│       └── widgets/
│           ├── stories_list.dart
│           ├── story_widget.dart
│           └── comment_widget.dart
└── widgets/
    ├── animated_indexed_stack.dart
    └── image_grid_item.dart
```

Логика разделения:

- **models** — описывают данные;
- **data** — начальные данные;
- **services** — доступ к данным и сети;
- **providers** — Riverpod: DI и state;
- **widgets** — переиспользуемые части UI;
- **screens** — экраны и вкладки.

### 2.1 Отдельный файл `lib/future_dart_example.dart`

Это не часть приложения и он нигде не импортируется. Файл показывает базовую работу с `Future` и `async/await`:

```dart
Future<void> futureFunction() async {
  await Future.delayed(Duration(seconds: 2));
  print("This is a future function that completes after a delay.");
}

Future<void> main() async {
  futureFunction()
      .then((_) => print("Future function completed."))
      .catchError((error) => print("An error occurred: $error"));
  print("Starting the main function.");
  notFuture();
}
```

Здесь видно, что `then` и `catchError` обрабатывают результат и ошибку асинхронной функции. Точка входа приложения — `main()` из `lib/main.dart`, а не этот файл.

---

## 4. Точка входа: `lib/main.dart`

```dart
void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
```

Что здесь важно:

1. **`ProviderScope`** — корневой контейнер Riverpod. Внутри него живут все providers и их state. Любой `ConsumerWidget` должен находиться ниже `ProviderScope`, иначе `ref` не найдёт контейнер. Поэтому `ProviderScope` оборачивает всё приложение.
2. **`MaterialApp`** — корневой widget: задаёт тему, навигацию и `home`.
3. **`debugShowCheckedModeBanner: false`** — убирает debug-ленту в правом верхнем углу.
4. `MainScreen` — первый экран приложения.

---

## 5. Главный экран и навигация

### 5.1 `lib/screens/main_screen.dart`

`MainScreen` — `StatefulWidget`, потому что хранит только локальный UI-state: индекс активной вкладки.

```dart
int _currentIndex = 0;

static const _items = [
  BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
  BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
  BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "New post"),
  BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Activity"),
  BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
];

static const _pages = [
  HomeTab(),
  SearchTab(),
  PlaceholderTab(title: "New post", icon: Icons.add_box),
  PlaceholderTab(title: "Activity", icon: Icons.favorite_border),
  PlaceholderTab(title: "Profile", icon: Icons.person_outline),
];
```

`BottomNavigationBar`:

- `currentIndex: _currentIndex`;
- `onTap: (index) => setState(() => _currentIndex = index)`;
- `type: BottomNavigationBarType.fixed` — при пяти вкладках нужен fixed, иначе Flutter включает shifting-режим;
- `showSelectedLabels: false` и `showUnselectedLabels: false` — только иконки, как в Instagram;
- цвета: выбранная иконка чёрная, остальные серые.

Почему индекс вкладки не в Riverpod: он нужен только `MainScreen` и не является бизнес-данными. Riverpod здесь был бы избыточен. Это хороший пример того, что **не всё состояние нужно выносить в глобальный state manager**.

### 5.2 `lib/widgets/animated_indexed_stack.dart`

Это замена стандартного `IndexedStack`. Задача — сохранять state каждой вкладки (позицию скролла, введённый текст) и добавлять анимацию переключения.

Как устроено:

- `Stack(fit: StackFit.expand)` — все страницы лежат друг на друге и занимают весь экран.
- Для каждой страницы:
  - `IgnorePointer(ignoring: !isActive)` — неактивная страница не принимает нажатия;
  - `AnimatedSlide` — активная страница с `Offset.zero`, неактивные сдвинуты на `±0.06` ширины, поэтому при переключении есть лёгкий слайд;
  - `AnimatedOpacity` — активная страница `opacity: 1`, остальные `0`;
  - `TickerMode(enabled: isActive)` — останавливает анимации внутри скрытых страниц;
  - `RepaintBoundary` — изолирует перерисовку страницы;
  - `_visited.contains(i) ? widget.children[i] : SizedBox.shrink()` — страница создаётся лениво, только после первого посещения.

`_visited` — `Set<int>`, стартует с текущего индекса. В `didUpdateWidget` добавляется новый индекс. Поэтому после первого открытия вкладка остаётся в дереве и не теряет scroll position.

Почему не обычный `IndexedStack`: он не анимирует переход и строит все страницы сразу. Почему не `PageView`: он добавляет swipe-жесты и другую модель жизненного цикла.

### 5.3 `lib/screens/tabs/placeholder_tab.dart`

Заглушка для вкладок New post, Activity и Profile. Принимает `title` и `icon`, показывает `AppBar` и большую серую иконку по центру.

---

## 6. Lab 5: посты и stories

### 6.1 Модели

**`CommentModel`** — комментарий:

```dart
class CommentModel {
  final String username;
  final String text;
  final String avatarPath;

  const CommentModel({
    required this.username,
    required this.text,
    required this.avatarPath,
  });
}
```

**`StoryModel`** — story:

```dart
class StoryModel {
  final String username;
  final String imagePath;
  final bool isSeen;

  const StoryModel({
    required this.username,
    required this.imagePath,
    this.isSeen = false,
  });
}
```

`isSeen` управляет цветом кольца: непросмотренная story — розовое кольцо, просмотренная — серое.

**`PostModel`** в Lab 6:

```dart
class PostModel {
  final int id;
  final String username;
  final String avatarPath;
  final String imagePath;
  final String description;
  final int likeCount;
  final bool isLiked;
  final bool isSaved;
  final List<CommentModel> comments;

  PostModel({
    required this.id,
    required this.username,
    required this.avatarPath,
    required this.imagePath,
    required this.description,
    required this.likeCount,
    required this.comments,
    this.isLiked = false,
    this.isSaved = false,
  });

  int get commentCount => comments.length;

  PostModel copyWith({int? likeCount, bool? isLiked, bool? isSaved}) {
    return PostModel(
      id: id,
      username: username,
      avatarPath: avatarPath,
      imagePath: imagePath,
      description: description,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      comments: comments,
    );
  }
}
```

Ключевые решения:

- все поля `final` — объект **immutable**;
- `id` нужен, чтобы находить пост в списке, не полагаясь на индекс;
- `isLiked` и `isSaved` — состояние UI, которое приходит из Riverpod;
- `copyWith` создаёт **новый** объект с изменёнными полями, старый не трогается.

### 6.2 Начальные данные: `lib/screens/home_screen/data/posts_data.dart`

Файл содержит:

- `sampleImagePath = "assets/images/post.jpg"` — одно изображение используется для постов, аватаров и stories;
- `postsData` — список из 10 постов, у каждого 2 комментария;
- `storiesData` — `const` список из 10 stories, у некоторых `isSeen: true`.

Данные вынесены из UI: экран не знает, откуда они берутся, он получает готовый список.

### 6.3 Сервис: `lib/screens/home_screen/services/post_services.dart`

```dart
class PostServices {
  final List<PostModel> posts = [];
  final List<StoryModel> stories = [];

  void batchAddPosts(List<PostModel> newPosts) {
    posts.addAll(newPosts);
  }

  void batchAddStories(List<StoryModel> newStories) {
    stories.addAll(newStories);
  }
}
```

Это слой доступа к данным, простая in-memory реализация репозитория. В Lab 5 у него были ещё методы `addPost`, `likePost`, `commentOnPost`, но в Lab 6 бизнес-логика переехала в `Notifier`, а сервис остался хранилищем данных. Это важно: **`PostServices` по-прежнему используется**, но уже внутри Riverpod, как требует задание.

### 6.4 `lib/screens/home_screen/widgets/stories_list.dart`

```dart
SizedBox(
  height: 120,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    itemCount: stories.length,
    itemBuilder: (context, index) => StoryWidget(story: stories[index]),
  ),
)
```

- Горизонтальный `ListView.builder` строит только видимые элементы.
- Высота фиксирована (`120`), потому что горизонтальный список должен получить ограничение по высоте от родителя. Если высоты не хватает, появляется `BOTTOM OVERFLOW`.

### 6.5 `lib/screens/home_screen/widgets/story_widget.dart`

```dart
Container(
  padding: const EdgeInsets.all(3),
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(
      color: story.isSeen ? Colors.grey.shade300 : Colors.pink,
      width: 2.5,
    ),
  ),
  child: CircleAvatar(
    radius: 31,
    backgroundColor: Colors.grey.shade200,
    backgroundImage: AssetImage(story.imagePath),
  ),
)
```

- `CircleAvatar` с `backgroundImage` даёт ровный круг без обрезки.
- Внешний `Container` с `BoxShape.circle` и `Border.all` рисует кольцо вокруг аватара.
- `isSeen` меняет цвет кольца.
- `Text` с `maxLines: 1` и `TextOverflow.ellipsis` не даёт длинному username сломать layout.

### 6.6 `lib/screens/content/post_widget.dart`

Структура карточки поста:

1. **Header** — `CircleAvatar` (radius 18), username, кнопка `more_horiz`.
2. **Изображение** — `AspectRatio(aspectRatio: 1)` + `Image.asset(..., fit: BoxFit.cover)`. Квадрат, как в Instagram, без искажений.
3. **Панель действий** — лайк, комментарий, отправка, `Spacer`, сохранение.
4. **Количество лайков** — `"${post.likeCount} likes"`.
5. **Подпись** — username + description.
6. **Первый комментарий** — `CommentWidget(comment: post.comments.first)`.
7. **Кнопка `View all N comments`** — если комментариев больше одного.

Комментарии открываются в `showModalBottomSheet`:

```dart
showModalBottomSheet<void>(
  context: context,
  backgroundColor: Colors.white,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  ),
  builder: (context) {
    return SizedBox(
      height: 380,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Text("Comments (${post.commentCount})", ...),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: post.comments.length,
              itemBuilder: (context, index) =>
                  CommentWidget(comment: post.comments[index]),
            ),
          ),
        ],
      ),
    );
  },
);
```

`Expanded` + `ListView.builder` нужны, чтобы список комментариев скроллился внутри фиксированной высоты 380.

### 6.7 `lib/screens/home_screen/widgets/comment_widget.dart`

В Lab 5 это был `StatelessWidget` без лайка. В Lab 6 добавлена кликабельная кнопка-сердечко:

```dart
class CommentWidget extends StatefulWidget {
  final CommentModel comment;

  const CommentWidget({super.key, required this.comment});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundImage: AssetImage(comment.avatarPath),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 4),
                Expanded(child: Text(comment.text)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _isLiked = !_isLiked),
            icon: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              size: 18,
              color: _isLiked ? Colors.red : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
```

Почему здесь `StatefulWidget`, а не Riverpod: лайк комментария — локальное визуальное состояние одного элемента. Он нигде больше не используется и не сохраняется. Для учебного проекта этого достаточно. В реальном приложении лайки комментариев хранились бы в repository/provider, чтобы синхронизироваться между экранами.

### 6.8 `HomeTab` в Lab 5

Тогда экран сам создавал сервис и наполнял его данными:

```dart
class _HomeTabState extends State<HomeTab> {
  final PostServices _postServices = PostServices();

  @override
  void initState() {
    super.initState();
    _postServices.batchAddPosts(postsData);
    _postServices.batchAddStories(storiesData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StoriesList(stories: _postServices.stories),
          Expanded(
            child: ListView.builder(
              itemCount: _postServices.posts.length,
              itemBuilder: (context, index) =>
                  PostWidget(post: _postServices.posts[index]),
            ),
          ),
        ],
      ),
    );
  }
}
```

Лайк в Lab 5 жил внутри `PostWidget`:

```dart
class _PostWidgetState extends State<PostWidget> {
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLiked;
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      widget.post.isLiked = _isLiked;
      widget.post.addLike(widget.post.likeCount + (_isLiked ? 1 : -1));
    });
  }
}
```

Проблемы такого подхода:

1. **Нет единого source of truth.** `_isLiked` хранится в widget, `likeCount` — в модели, и они могут разойтись.
2. **Модель mutable.** `PostModel` имел `int likeCount`, `bool isLiked`, методы `addLike` и `addComment`.
3. **Сервис создаётся внутри экрана.** Другой экран не может получить те же данные, а в тесте нельзя подменить сервис на fake.
4. **Логика в UI.** Чтобы протестировать лайк, нужен widget test.
5. **`setState` обновляет только этот `PostWidget`.** Если тот же пост показан ещё где-то, второй экземпляр не узнает об изменении.

Именно эти проблемы решает Lab 6.

---

## 7. Lab 6: Riverpod и Dependency Injection

### 7.1 Что такое Riverpod в одном предложении

Riverpod — это контейнер для **state** и **зависимостей**: providers создают и хранят объекты, виджеты подписываются на них через `ref.watch`, а менять state могут через методы `Notifier`.

### 7.2 `ProviderScope`

```dart
runApp(const ProviderScope(child: MainApp()));
```

`ProviderScope` создаёт `ProviderContainer` — хранилище всех providers. Он должен быть выше любого `ConsumerWidget`. В приложении он один, в тестах можно создать отдельный `ProviderContainer`.

### 7.3 `lib/screens/home_screen/providers/post_providers.dart`

Полный файл:

```dart
final postServicesProvider = Provider<PostServices>((ref) {
  final postServices = PostServices();
  postServices.batchAddPosts(postsData);
  postServices.batchAddStories(storiesData);
  return postServices;
});

final storiesProvider = Provider<List<StoryModel>>((ref) {
  return ref.watch(postServicesProvider).stories;
});

class PostsNotifier extends Notifier<List<PostModel>> {
  @override
  List<PostModel> build() {
    return List.of(ref.watch(postServicesProvider).posts);
  }

  void toggleLike(int id) {
    state = [
      for (final post in state)
        if (post.id == id)
          post.copyWith(
            isLiked: !post.isLiked,
            likeCount: post.likeCount + (post.isLiked ? -1 : 1),
          )
        else
          post,
    ];
  }

  void toggleSave(int id) {
    state = [
      for (final post in state)
        if (post.id == id) post.copyWith(isSaved: !post.isSaved) else post,
    ];
  }
}

final postsProvider = NotifierProvider<PostsNotifier, List<PostModel>>(
  PostsNotifier.new,
);
```

Разберём по частям.

#### `postServicesProvider` — это и есть Dependency Injection

```dart
final postServicesProvider = Provider<PostServices>((ref) {
  final postServices = PostServices();
  postServices.batchAddPosts(postsData);
  postServices.batchAddStories(storiesData);
  return postServices;
});
```

- `Provider<PostServices>` — read-only provider, который создаёт зависимость.
- Внутри создаётся **один** экземпляр `PostServices`, в него загружаются данные, и он возвращается.
- Riverpod кэширует результат: сколько бы виджетов ни читали provider, `PostServices()` создастся один раз.
- Виджеты больше не пишут `PostServices()` сами. Они получают готовый объект через `ref.watch`/`ref.read`.

Это и есть **Dependency Injection**: зависимость создаётся в одном месте и внедряется туда, где нужна. В тестах её можно заменить:

```dart
ProviderScope(
  overrides: [
    postServicesProvider.overrideWithValue(fakePostServices),
  ],
  child: const MainApp(),
)
```

В Lab 5 `PostServices` создавался внутри `_HomeTabState`, поэтому подменить его было нельзя.

#### `storiesProvider` — производная зависимость

```dart
final storiesProvider = Provider<List<StoryModel>>((ref) {
  return ref.watch(postServicesProvider).stories;
});
```

- Stories только читаются, поэтому достаточно `Provider`, а не `NotifierProvider`.
- `ref.watch(postServicesProvider)` означает: если сервис изменится, этот provider пересчитается.
- Если бы нужно было отмечать story просмотренной, понадобился бы `Notifier<List<StoryModel>>` с методом `markSeen`.

#### `PostsNotifier` — state + бизнес-логика

```dart
class PostsNotifier extends Notifier<List<PostModel>> {
  @override
  List<PostModel> build() {
    return List.of(ref.watch(postServicesProvider).posts);
  }
```

- `Notifier<List<PostModel>>` — класс, который хранит состояние типа `List<PostModel>`.
- `build()` вызывается при первом чтении provider и возвращает начальное состояние.
- `List.of(...)` создаёт **копию** списка. Это важно: state не должен быть тем же списком, что внутри `PostServices`, иначе изменения state могли бы незаметно менять сервис.

`toggleLike`:

```dart
state = [
  for (final post in state)
    if (post.id == id)
      post.copyWith(
        isLiked: !post.isLiked,
        likeCount: post.likeCount + (post.isLiked ? -1 : 1),
      )
    else
      post,
];
```

- создаётся новый список;
- нужный пост заменяется новым объектом через `copyWith`;
- остальные посты остаются как были;
- присваивание `state = ...` уведомляет всех подписчиков;
- лайк и количество меняются согласованно: `isLiked` переключается, `likeCount` увеличивается или уменьшается на 1.

`toggleSave` устроен так же, но меняет только `isSaved`.

Почему это лучше Lab 5:

- единый source of truth — список в notifier;
- модель immutable, нет скрытых мутаций;
- логика отделена от UI и легко тестируется;
- любой виджет, который смотрит на `postsProvider`, обновится автоматически.

#### `postsProvider`

```dart
final postsProvider = NotifierProvider<PostsNotifier, List<PostModel>>(
  PostsNotifier.new,
);
```

`NotifierProvider` связывает notifier и тип его state. `PostsNotifier.new` — constructor tear-off, то есть ссылка на конструктор, а не вызов.

### 7.4 `ConsumerWidget`, `ref.watch` и `ref.read`

**`HomeTab`** стал `ConsumerWidget`:

```dart
class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProvider);
    final stories = ref.watch(storiesProvider);

    return Scaffold(
      body: Column(
        children: [
          StoriesList(stories: stories),
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) =>
                  PostWidget(post: posts[index]),
            ),
          ),
        ],
      ),
    );
  }
}
```

- `ConsumerWidget` — это `StatelessWidget`, у которого в `build` есть `WidgetRef ref`.
- `ref.watch(postsProvider)` подписывает `HomeTab` на changes. Когда notifier меняет `state`, Flutter перестраивает `HomeTab`, `ListView` и все `PostWidget` с новыми данными.
- `ref.watch(storiesProvider)` работает так же для stories.

**`PostWidget`** тоже `ConsumerWidget`, но использует `ref.read`:

```dart
IconButton(
  onPressed: () {
    ref.read(postsProvider.notifier).toggleLike(post.id);
  },
  icon: Icon(
    post.isLiked ? Icons.favorite : Icons.favorite_border,
    color: post.isLiked ? Colors.red : null,
  ),
)
```

Правило:

- `ref.watch` — только в `build`, когда нужна подписка и rebuild;
- `ref.read` — в обработчиках (`onPressed`), когда нужно просто вызвать метод без подписки.

`ref.read(postsProvider.notifier)` возвращает notifier, а `.toggleLike(post.id)` меняет state. `PostWidget` сам не хранит лайк: он берёт `post.isLiked` из списка, который пришёл от `HomeTab`.

Почему `PostWidget` не делает `ref.watch(postsProvider)`? Потому что его родитель `HomeTab` уже подписан: после изменения state родитель перестроится и передаст новый `post` в конструктор. Если бы `PostWidget` использовался отдельно, без подписанного родителя, тогда `watch` был бы нужен.

### 7.5 Immutable-обновления и `copyWith`

В Lab 5:

```dart
post.isLiked = !post.isLiked;
post.addLike(post.likeCount + 1);
```

В Lab 6:

```dart
post.copyWith(
  isLiked: !post.isLiked,
  likeCount: post.likeCount + (post.isLiked ? -1 : 1),
)
```

Почему immutable лучше:

- старый объект не меняется неожиданно;
- Riverpod видит новую ссылку и гарантированно уведомляет подписчиков;
- проще отлаживать: состояние можно сравнивать;
- проще тестировать: не нужно следить за побочными эффектами.

---

## 8. Полный поток данных

```text
ProviderScope
│
├── postServicesProvider
│     создаёт PostServices
│     загружает postsData и storiesData
│
├── storiesProvider
│     читает postServicesProvider.stories
│     └── HomeTab (ref.watch) → StoriesList → StoryWidget
│
└── postsProvider (NotifierProvider)
      PostsNotifier.build()
      возвращает List.of(service.posts)
      └── HomeTab (ref.watch) → ListView → PostWidget
                                              │
                                              │ onPressed
                                              ▼
                                   ref.read(postsProvider.notifier)
                                   toggleLike / toggleSave
                                              │
                                              ▼
                                   новый List<PostModel>
                                   state = ...
                                              │
                                              ▼
                                   Riverpod уведомляет HomeTab
                                   HomeTab и PostWidget перестраиваются
```

---

## 9. Lab 5 → Lab 6: что именно изменилось

| Аспект | Lab 5 | Lab 6 | Зачем |
|---|---|---|---|
| Владелец state | `_HomeTabState` + `_PostWidgetState` | `PostsNotifier` | единый source of truth |
| Создание сервиса | `final _postServices = PostServices()` внутри экрана | `postServicesProvider` | Dependency Injection |
| `PostModel` | mutable: `int likeCount`, `bool isLiked`, `addLike` | immutable: `final`, `copyWith` | предсказуемые обновления |
| `id` поста | не было | добавлен | стабильный поиск элемента |
| Лайк | `setState` + мутация модели | `toggleLike(id)` в notifier | логика вне UI |
| Сохранение | иконка ничего не делала | `toggleSave(id)` + `isSaved` | кликабельная кнопка |
| Stories | читались напрямую из сервиса | `storiesProvider` | единый доступ к данным |
| `HomeTab` | `StatefulWidget` | `ConsumerWidget` | подписка на providers |
| `PostWidget` | `StatefulWidget` | `ConsumerWidget` | доступ к notifier |
| Тесты | не было | provider + widget tests | проверка логики |
| Изображения | `NetworkImage` / `Image.network` | `AssetImage` / `Image.asset` | надёжный демо-режим |

### 9.1 Код до и после

**Создание сервиса.**

Lab 5:

```dart
class _HomeTabState extends State<HomeTab> {
  final PostServices _postServices = PostServices();

  @override
  void initState() {
    super.initState();
    _postServices.batchAddPosts(postsData);
    _postServices.batchAddStories(storiesData);
  }
}
```

Lab 6:

```dart
final postServicesProvider = Provider<PostServices>((ref) {
  final postServices = PostServices();
  postServices.batchAddPosts(postsData);
  postServices.batchAddStories(storiesData);
  return postServices;
});
```

**Лайк.**

Lab 5:

```dart
void _toggleLike() {
  setState(() {
    _isLiked = !_isLiked;
    widget.post.isLiked = _isLiked;
    widget.post.addLike(widget.post.likeCount + (_isLiked ? 1 : -1));
  });
}
```

Lab 6:

```dart
void toggleLike(int id) {
  state = [
    for (final post in state)
      if (post.id == id)
        post.copyWith(
          isLiked: !post.isLiked,
          likeCount: post.likeCount + (post.isLiked ? -1 : 1),
        )
      else
        post,
  ];
}
```

**Чтение данных.**

Lab 5:

```dart
StoriesList(stories: _postServices.stories);
...
PostWidget(post: _postServices.posts[index]);
```

Lab 6:

```dart
final posts = ref.watch(postsProvider);
final stories = ref.watch(storiesProvider);
...
StoriesList(stories: stories);
...
PostWidget(post: posts[index]);
```

### 9.2 Что осталось из Lab 5

- структура моделей и папок;
- `PostServices` как слой данных;
- `StoriesList`, `StoryWidget`, `CommentWidget`;
- layout карточки поста;
- bottom sheet с комментариями;
- `HomeTab` как экран ленты;
- `SearchTab` с Dio;
- нижняя навигация и `AnimatedIndexedStack`.

То есть Lab 6 не переписал приложение с нуля, а заменил управление состоянием и доступ к зависимостям.

---

## 10. Вкладка Search и экран деталей

### 10.1 `lib/screens/home_screen/services/dio_service.dart`

```dart
class DioService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> get(String url, int limit) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: {'limit': limit},
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
```

- `Dio` — HTTP-клиент.
- `get` возвращает `Future<Map<String, dynamic>>`, потому что ответ — JSON-объект.
- `queryParameters` добавляет `?limit=10`.
- Ошибка оборачивается в `Exception`, чтобы `FutureBuilder` показал понятное сообщение.

### 10.2 `lib/screens/tabs/search_tab.dart`

```dart
class _SearchTabState extends State<SearchTab> {
  DioService dioService = DioService();
  late Future<List<dynamic>> _futureData;

  Future<List<dynamic>> fetchData() async {
    final response = await dioService.get(
      'https://dummyjson.com/products',
      10,
    );
    return response['products'] as List<dynamic>;
  }

  @override
  void initState() {
    super.initState();
    _futureData = fetchData();
  }
}
```

Почему `StatefulWidget`:

- `Future` создаётся один раз в `initState`, а не при каждом rebuild;
- иначе каждый `build` запускал бы новый запрос.

`FutureBuilder` обрабатывает три состояния:

1. `ConnectionState.waiting` — `CircularProgressIndicator`;
2. `snapshot.hasError` — текст ошибки;
3. данные есть — `GridView.builder`.

```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    crossAxisSpacing: 4.0,
    mainAxisSpacing: 4.0,
  ),
  itemCount: data.length,
  itemBuilder: (context, index) {
    final item = data[index];
    return ImageGridItem(
      imagePath: "assets/images/search_${(index % 3) + 1}.jpg",
      description: item['description'],
      title: item['title'],
    );
  },
)
```

- `crossAxisCount: 3` — три квадрата в ряд, поэтому они меньше, чем при двух;
- `index % 3` циклически выбирает `search_1.jpg`, `search_2.jpg`, `search_3.jpg`;
- title и description приходят из API, изображения — локальные.

### 10.3 `lib/widgets/image_grid_item.dart`

```dart
GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContentDetailScreen(
          imagePath: imagePath,
          description: description,
          title: title,
        ),
      ),
    );
  },
  child: Container(
    decoration: BoxDecoration(
      color: Colors.grey[300],
      image: DecorationImage(
        image: AssetImage(imagePath),
        fit: BoxFit.cover,
      ),
    ),
  ),
)
```

- `GridView` задаёт размер ячейки, `Container` заполняет её;
- `BoxFit.cover` обрезает изображение без искажений;
- `Navigator.push` открывает экран деталей.

### 10.4 `lib/screens/content_detail_screen.dart`

```dart
Scaffold(
  appBar: AppBar(title: Text(title)),
  body: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(imagePath),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(description, style: const TextStyle(fontSize: 16.0)),
        ),
      ],
    ),
  ),
)
```

`SingleChildScrollView` нужен, потому что описание может быть длинным и не помещаться на экране.

---

## 11. UI-доработки после Lab 6

Это не относится к core Riverpod, но входит в текущую версию проекта:

1. **Локальные изображения.** `assets/images/post.jpg` и `search_1..3.jpg` вместо сетевых. В `pubspec.yaml` подключена папка `assets/images/`. Это делает демонстрацию стабильной и не зависит от сети.
2. **Кнопка сохранения.** Иконка `bookmark_border` меняется на `bookmark`, состояние хранится в `PostModel.isSaved` через `toggleSave`. Сохранение не пишется на диск: после перезапуска приложения оно сбрасывается. Так и было задумано — кнопка должна быть кликабельной, но не обязана сохранять данные.
3. **Лайк комментария.** Локальный `_isLiked` в `CommentWidget`, красное сердечко при нажатии.
4. **Сетка Search.** 3 колонки вместо 2, изображения циклически берутся из трёх локальных файлов.
5. **Stories.** Высота списка 120 и `CircleAvatar` с `backgroundImage`, чтобы не было overflow и круги выглядели ровно.
6. **Имена.** Все username намеренно с опечатками, кроме `aminloh` — это требование к демонстрационным данным.

---

## 12. Как показывать проект куратору

### 12.1 Порядок рассказа

1. **Общая идея.** «Это Instagram-клон: лента, stories, лайки, комментарии, поиск».
2. **Структура.** Показать папки `models`, `data`, `services`, `providers`, `widgets`, `screens`.
3. **Lab 5.** Модели `PostModel`, `StoryModel`, `CommentModel`; `posts_data.dart`; `PostServices`; `StoriesList`/`StoryWidget`; `PostWidget`; bottom sheet комментариев.
4. **Проблема Lab 5.** Сервис создаётся внутри экрана, лайк живёт в `setState`, модель mutable, логику нельзя протестировать отдельно.
5. **Lab 6.** `ProviderScope`; `postServicesProvider` как DI; `storiesProvider`; `PostsNotifier` и `postsProvider`; `ConsumerWidget`; `ref.watch`/`ref.read`; immutable `copyWith`.
6. **Результат.** Единый source of truth, автоматический rebuild, DI, тесты.
7. **Демонстрация.** Лайк, сохранение, комментарии, Search.
8. **Ограничения.** Данные в памяти, сохранение не персистится, комментарии локальные.

### 12.2 Что нажать в приложении

1. Открыть Home: показать stories и 10 постов.
2. Нажать сердечко поста: счётчик увеличился, сердечко красное. Нажать ещё раз: вернулось.
3. Нажать bookmark: иконка закрасилась. Нажать ещё раз: снова контур.
4. Нажать иконку комментария: открылся bottom sheet. Нажать сердечко у комментария: оно стало красным.
5. Перейти в Search: сетка 3 колонки. Нажать на квадрат: открылся экран с изображением и описанием. Вернуться назад.
6. Переключиться между вкладками: состояние и скролл сохраняются благодаря `AnimatedIndexedStack`.

### 12.3 Команды

```bash
flutter run -d macos
flutter analyze
flutter test
```

Ожидаемый результат:

- `flutter analyze` — только старые `avoid_print` info в `future_dart_example.dart`;
- `flutter test` — 3 теста проходят.

---

## 13. Тесты

### 13.1 `test/posts_notifier_test.dart`

```dart
test("toggleLike updates the post", () {
  final container = ProviderContainer();
  addTearDown(container.dispose);

  final post = container.read(postsProvider).first;

  container.read(postsProvider.notifier).toggleLike(post.id);
  final likedPost = container.read(postsProvider).first;

  expect(likedPost.isLiked, isTrue);
  expect(likedPost.likeCount, post.likeCount + 1);

  container.read(postsProvider.notifier).toggleLike(post.id);
  final unlikedPost = container.read(postsProvider).first;

  expect(unlikedPost.isLiked, isFalse);
  expect(unlikedPost.likeCount, post.likeCount);
});
```

- `ProviderContainer` — тот же контейнер, что создаёт `ProviderScope`, но без UI.
- `container.read(postsProvider)` — получить текущий state.
- `container.read(postsProvider.notifier)` — получить notifier и вызвать метод.
- `addTearDown(container.dispose)` — очистка после теста.

Второй тест проверяет `toggleSave`: `false → true → false`.

### 13.2 `test/tab_switch_test.dart`

Widget test для `AnimatedIndexedStack`: проверяет, что после переключения видима только активная страница. Используется `AnimatedOpacity` и `RenderAnimatedOpacity.opacity.value`, чтобы отличить `opacity: 1` от `0`.

---

## 14. Вероятные вопросы куратора и ответы

**1. Где здесь Dependency Injection?**

В `postServicesProvider`. Он создаёт `PostServices` и загружает данные. `PostsNotifier` и `storiesProvider` получают сервис через `ref.watch`, а не создают его сами. В тестах зависимость можно заменить через `overrides`.

**2. Почему `Provider`, а не просто глобальная переменная?**

`Provider` кэширует объект, управляет временем жизни, поддерживает подписки и overrides в тестах. Глобальная переменная не даёт ни того, ни другого.

**3. Почему `Notifier`, а не `StateNotifier`?**

`Notifier` — современный API Riverpod, меньше boilerplate и нет отдельного класса состояния. `StateNotifier` считается legacy.

**4. Почему `storiesProvider` — обычный `Provider`, а `postsProvider` — `NotifierProvider`?**

Stories только читаются. Posts меняются (лайк, сохранение), поэтому нужен notifier с методами и изменяемым state.

**5. Почему `ref.watch`, а не `ref.read` в `HomeTab`?**

`watch` подписывает на изменения и вызывает rebuild. `read` в `build` не обновлял бы экран.

**6. Почему `ref.read` в `onPressed`?**

Обработчик не должен создавать подписку. Он просто вызывает метод notifier. Подписка уже есть у `HomeTab`.

**7. Почему `List.of` в `build`?**

Чтобы state notifier был отдельным списком, а не тем же объектом, что `PostServices.posts`. Иначе изменения state могли бы менять сервис напрямую.

**8. Почему `id`, а не индекс?**

Индекс меняется при фильтрации или сортировке. `id` — стабильный идентификатор поста.

**9. Почему лайк комментария не в Riverpod?**

Это локальное состояние одного widget. Оно нигде не шарится. Если бы лайки комментариев нужно было синхронизировать, мы бы вынесли их в provider/repository.

**10. Сохраняется ли bookmark после перезапуска?**

Нет. `isSaved` живёт в памяти Riverpod. Для persistence нужны `shared_preferences`, база данных или backend. По заданию достаточно кликабельной кнопки.

**11. Почему `MainScreen` остался `StatefulWidget`?**

Индекс вкладки — локальный UI-state, он не нужен другим экранам. Riverpod для него был бы избыточен.

**12. Почему изображения локальные?**

Так демонстрация не зависит от сети и macOS sandbox. Все файлы подключены в `pubspec.yaml` и лежат в `assets/images/`.

**13. Что произойдёт при `state = ...`?**

Riverpod сравнивает новое значение со старым, уведомляет подписчиков и вызывает rebuild у `ConsumerWidget`, которые делают `ref.watch`.

**14. Можно ли добавить новый пост?**

Да. Нужно добавить метод в `PostsNotifier`, который создаёт новый `PostModel` и добавляет его в state. Сейчас это не требуется по заданию, поэтому метода нет.

**15. Почему `PostWidget` — `ConsumerWidget`, если он не делает `watch`?**

Ему нужен `ref`, чтобы в `onPressed` вызвать `ref.read(postsProvider.notifier)`. `ConsumerWidget` даёт доступ к `WidgetRef`.

---

## 15. Короткая версия для устного ответа

> Проект — Instagram-клон на Flutter. В Lab 5 я сделал модели `PostModel`, `StoryModel`, `CommentModel`, локальные данные, сервис `PostServices`, ленту постов, stories и комментарии. Состояние тогда жило в `StatefulWidget` через `setState`, а сервис создавался внутри экрана.
>
> В Lab 6 я добавил Riverpod как state manager и Dependency Injection. Обернул приложение в `ProviderScope`, создал `postServicesProvider`, который один раз создаёт и наполняет `PostServices`, и `storiesProvider` для stories. Посты хранятся в `PostsNotifier` через `NotifierProvider`: методы `toggleLike` и `toggleSave` создают новый список с обновлённым постом через `copyWith`, поэтому модель стала immutable. `HomeTab` и `PostWidget` стали `ConsumerWidget`: `HomeTab` делает `ref.watch` и перестраивается при изменении state, а `PostWidget` через `ref.read` вызывает методы notifier.
>
> В результате появился единый source of truth, автоматическое обновление UI, возможность подменить зависимость в тестах и отдельные тесты на лайк и сохранение. Дополнительно я добавил кликабельную кнопку сохранения, лайки комментариев, локальные изображения и сетку Search в три колонки.
