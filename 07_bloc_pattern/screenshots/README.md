# Screenshots Reference - Phase 7: BLoC Pattern

Đây là mô tả các screenshots cho từng exercise trong Phase 7.

## Lesson 1: Streams

### Ex01: Stream Controller
- **Initial**: Counter hiển thị 0, có nút +1, -1, Reset
- **After Actions**: Giá trị thay đổi theo nút được bấm, stream events được log

### Ex02: Stream Transformations
- **Pipeline View**: Hiển thị luồng dữ liệu Input → where → map → distinct → Output
- **Log Panel**: Showing transformation steps for each number

### Ex03: StreamBuilder Widget
- **States**: Hiển thị ConnectionState (waiting, active, done)
- **Error Handling**: Red error message when error occurs

## Lesson 2: Cubit

### Ex04: Counter Cubit
- **Counter Display**: Large number với màu (green/red/grey)
- **Buttons**: +1, -1, Reset floating action buttons

### Ex05: Theme Cubit
- **Light Mode**: Sun icon, light background
- **Dark Mode**: Moon icon, dark background
- **Radio Selection**: Light/Dark/System options

### Ex06: Timer Cubit
- **Circular Progress**: Timer countdown với progress indicator
- **Controls**: Start (10s, 30s, 1m, 2m), Pause/Resume, Reset

## Lesson 3: BLoC

### Ex07: Counter BLoC
- **Similar to Ex04**: But using Events instead of methods
- **Flow Diagram**: Showing Button → add(Event) → Handler → emit

### Ex08: Auth BLoC
- **Login Form**: Username/Password fields
- **States**: Initial (form), Loading (spinner), Success (profile), Error (message)

### Ex09: Form Validation
- **Reactive Fields**: Email, Password, Confirm Password
- **Validation**: Green checkmarks when valid, error messages when invalid
- **Submit Button**: Enabled only when all fields valid

### Ex10: BlocObserver
- **Log Console**: Black background với colored logs
- **Event Types**: CREATE, EVENT, CHANGE, TRANSITION, ERROR, CLOSE

## Lesson 4: Widgets

### Ex11: BlocBuilder
- **Rebuild Counter**: Shows rebuild count for each card
- **buildWhen**: Cards rebuild independently based on conditions

### Ex12: BlocListener
- **SnackBars**: Success (green), Error (red)
- **Navigation**: Navigates to detail page

### Ex13: BlocConsumer
- **Dice Game**: Dice display, roll button
- **Win Dialog**: Appears when rolling 6

### Ex14: BlocSelector
- **Profile Cards**: Full Name, Age, Verified status
- **Rebuild Tracking**: Shows which cards rebuild per action

## Lesson 5: Architecture

### Ex15: Todo App
- **Todo List**: Checkboxes, swipe to delete
- **Filters**: All/Active/Completed tabs
- **Stats Bar**: Total, Active, Completed counts

### Ex16: Weather App
- **Search**: City input field
- **Weather Card**: Temperature, condition icon, humidity, wind
- **States**: Initial, Loading, Loaded, Error

### Ex17: User CRUD
- **User List**: Avatar, name, email
- **Actions**: Add (FAB), Edit (icon), Delete (icon)
- **Dialogs**: Add/Edit user forms

---

> 💡 **Tip**: Run `flutter run -d chrome` to see live exercises
