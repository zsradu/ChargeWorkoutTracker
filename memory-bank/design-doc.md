# Charge - Workout Tracker Design Document

## Overview
Charge is a mobile fitness app for Android and iOS that lets users track workout routines and monitor progress, with all data stored locally on the device.

## App Structure

### Screens

#### Track Page
- **Purpose**: Main page showing the workout log for a selected day (default: current day).
- **Elements**:
  - Selected date display.
  - List of logged exercises (e.g., "3 sets x 10 reps @ 10kg").
  - "Add" button to open the Select Exercise menu.

#### Calendar Page
- **Purpose**: View and select days to see workout logs.
- **Elements**:
  - Monthly calendar with navigation buttons (previous/next month).
  - Dots under days with workouts.
  - Clicking a day opens the Track page for that day.

#### Progress Page
- **Purpose**: Show workout progress metrics.
- **Elements**:
  - Dropdown: "General" (default) or specific exercises.
  - "General": Metric TBD (e.g., workouts per week).
  - Specific exercises: Graph of weight and reps vs. workout sequence (not date).
  - Access Select Exercise menu from dropdown.

#### Select Exercise Menu
- **Purpose**: Choose exercises to log or view progress.
- **Elements**:
  - Search bar for exercises.
  - Muscle group list; selecting one shows exercises in that group.
  - Option to add custom exercises.
- **Behavior**:
  - From Track page: Opens Exercise Logging page.
  - From Progress page: Shows progress graph.

#### Exercise Logging Page
- **Purpose**: Log an exercise for the selected day.
- **Elements**:
  - Exercise name and photo.
  - Inputs: Weight (default 10kg), Reps (default 10), Sets (default 3).
  - Save button to add to log.

#### Profile Page
- **Purpose**: App info and settings.
- **Elements**:
  - App description.
  - Unit settings (metric/imperial).

### Navigation
- **Top Bar (Track Page only)**:
  - Calendar button to open Calendar page.
- **Bottom Bar (All Pages)**:
  - "Track": Go to Track page.
  - "Progress": Go to Progress page.
  - "Profile": Go to Profile page.

## Data Model
Local database schema for persistent storage:

### Exercises Table
- `id` (integer, primary key)
- `name` (text)
- `muscle_group` (text)
- `image_path` (text, optional)

### Workouts Table
- `id` (integer, primary key)
- `date` (date)
- `exercise_id` (integer, foreign key to Exercises)
- `sets` (integer)
- `reps` (integer)
- `weight` (real)

### Custom_Exercises Table
- `id` (integer, primary key)
- `name` (text)
- `muscle_group` (text)

**Note**: Include a predefined set of common exercises by muscle group.

## User Flow
1. **Start**: Lands on Track page (current day).
2. **Log Workout**: "Add" → Select Exercise → Log details → Save.
3. **View Past**: Calendar → Pick day → Track page.
4. **Check Progress**: Progress → Select type or exercise → View graph.
5. **Settings**: Profile → Adjust units.

## Key Requirements
- Platforms: Android and iOS.
- Offline functionality with local data storage.
- Progress graphs plot against workout sequence, not time.
- Intuitive UI with standard mobile patterns.