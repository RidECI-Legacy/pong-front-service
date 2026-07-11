# RidECI Design System

> **Version 1.0**
>
> A premium, modern, and scalable design system for the RidECI platform.
>
> This design system should be used consistently across:
>
> - Landing Page
> - Authentication
> - Driver Dashboard
> - Passenger Dashboard
> - Administrator Dashboard
> - Flutter Mobile App
> - Flutter Web

---

# Design Philosophy

RidECI is **not** a traditional university platform.

It should feel like a modern technology startup built with the same design quality as:

- Linear
- Stripe
- Vercel
- Arc Browser
- Notion
- Apple
- Rivian

The interface should communicate:

- Trust
- Safety
- Simplicity
- Community
- Innovation

---

# Core Principles

## 1. Clean

Avoid visual noise.

Every component must have a purpose.

---

## 2. Spacious

Use generous spacing.

Never overcrowd information.

---

## 3. Consistent

Every page should use the same:

- Buttons
- Cards
- Inputs
- Icons
- Colors
- Typography
- Animations

---

## 4. Motion

Animations should feel natural.

Nothing should appear instantly.

Everything should smoothly transition.

---

# Color System

## Background

Primary

```
#13171D
```

Secondary

```
#171C23
```

Surface

```
#1D232C
```

Elevated Surface

```
#232B36
```

Sidebar

```
#171C23
```

Modal

```
#202733
```

---

## Brand Colors

Primary

```
#35E6B5
```

Primary Hover

```
#4EF0C4
```

Primary Pressed

```
#27C79A
```

---

Secondary Accent

```
#4DA3FF
```

---

Success

```
#35E6B5
```

Warning

```
#FFC857
```

Danger

```
#FF5C73
```

Info

```
#60A5FA
```

---

## Text

Primary

```
White
```

Secondary

```
White70
```

Muted

```
White54
```

Disabled

```
White30
```

---

## Borders

```
#2B3442
```

---

# Typography

## Font Family

Headings

Space Grotesk

Body

Inter

---

# Heading Scale

H1

48px

Bold

---

H2

36px

SemiBold

---

H3

28px

SemiBold

---

H4

22px

Medium

---

Body Large

18px

Regular

---

Body

16px

Regular

---

Small

14px

Regular

---

Caption

12px

Medium

---

# Border Radius

Cards

```
20px
```

Buttons

```
14px
```

Inputs

```
14px
```

Badges

```
999px
```

Dialogs

```
24px
```

---

# Spacing Scale

```
4
8
12
16
20
24
32
40
48
64
80
96
```

Always use multiples of this scale.

---

# Shadows

Card

Soft shadow

Blur 20

Opacity 10%

---

Hover

Blur 30

Opacity 20%

---

Floating

Blur 40

Opacity 25%

---

# Buttons

## Primary Button

Background

Primary Green

Text

White

Height

52px

Radius

14px

Hover

Slight glow

Lift 2px

Pressed

Scale 0.98

---

## Secondary Button

Dark background

Border

Primary

Text

White

Hover

Soft fill

---

## Ghost Button

Transparent

Hover

Dark Surface

---

## Icon Button

48x48

Circular

Hover

Background fade

---

# Cards

Background

Surface

Radius

20px

Padding

24px

Border

1px

Border Color

```
#2B3442
```

Hover

Lift

Glow

Border highlight

---

# Statistic Card

Contains

- Icon
- Title
- Main Value
- Trend
- Mini Chart (optional)

---

# Input Fields

Height

56px

Radius

14px

Leading Icon

Optional

Trailing Icon

Optional

States

Default

Focused

Success

Error

Disabled

Focus

Blue Glow

Border animation

---

# Search Bar

Rounded

Glass effect

Search icon

Placeholder

Animated focus

---

# Dropdown

Rounded

Dark

Smooth open animation

Hover state

---

# Checkboxes

Rounded

Primary Green

Animated checkmark

---

# Radio Buttons

Filled animation

Primary Green

---

# Switch

Rounded

Animated thumb

---

# Chips

Filled

Outlined

Filter Chips

Status Chips

---

# Badges

Success

Green

Pending

Yellow

Danger

Red

Info

Blue

---

# Tables

Rounded

Sticky Header

Search

Pagination

Hover Row

Status Badges

Actions

---

# Charts

Dark background

Rounded

Minimal grid

Soft turquoise lines

Animated values

---

# Navigation

Sidebar

Rounded active item

Animated indicator

Hover animation

Icon + Label

---

Topbar

Search

Notifications

Avatar

Role

Settings

---

# Modals

Rounded

Blur background

Fade animation

Scale animation

Primary action

Secondary action

---

# Bottom Sheets (Mobile)

Rounded Top

Drag Handle

Smooth open animation

---

# Toast Notifications

Rounded

Blur

Icon

Colored accent

Auto dismiss

---

# Avatars

Circle

Optional online indicator

Status badge

---

# Icons

Use

Lucide Icons

or

Material Symbols Rounded

Size

20

24

28

---

# Animations

Cards

Fade + Slide

250ms

---

Buttons

Scale

150ms

---

Page Transition

Fade

Slide

300ms

---

Sidebar

Smooth selection

200ms

---

Counters

Animated numbers

---

Charts

Draw animation

---

Hover

Elevation

Glow

---

Loading

Skeleton shimmer

Never block the UI.

---

# Dashboard Layout

```
---------------------------------------------------------

 Sidebar | Top Bar

         |

         | Hero Section

         |

         | Statistics

         |

         | Main Content

         |

         | Recent Activity

---------------------------------------------------------
```

---

# Component Library

The application should be built using reusable widgets.

## Buttons

- PrimaryButton
- SecondaryButton
- GhostButton
- IconButton

---

## Cards

- BaseCard
- StatsCard
- UserCard
- TripCard
- VehicleCard
- NotificationCard
- ReportCard

---

## Inputs

- TextField
- PasswordField
- SearchField
- DropdownField

---

## Navigation

- Sidebar
- Topbar
- BottomNavigation
- Breadcrumb

---

## Feedback

- Toast
- Snackbar
- AlertDialog
- ConfirmationDialog

---

## Data

- Table
- Chart
- EmptyState
- LoadingState

---

## Security Components

- EmergencyCard
- ReportCard
- VerificationBadge
- RatingWidget

---

# Icons by Module

## Driver

Car

Map

Route

Fuel

Calendar

Statistics

---

## Passenger

Search

Location

Clock

Favorite

History

---

## Admin

Shield

Users

Analytics

Reports

Verification

Alerts

---

# Responsive Breakpoints

Mobile

0–768px

Tablet

768–1024px

Desktop

1024–1440px

Large Desktop

1440px+

---

# Accessibility

Minimum contrast ratio AA.

Keyboard navigation.

Visible focus states.

Touch targets ≥ 48px.

Semantic widgets.

---

# Final Objective

Every screen of RidECI should feel like it belongs to the same premium ecosystem.

A user should instantly recognize the application's identity regardless of whether they are using:

- Landing Page
- Login
- Registration
- Driver Dashboard
- Passenger Dashboard
- Administrator Dashboard
- Mobile App

The experience should be modern, elegant, fluid, and consistent, matching the quality standards of Linear, Stripe, Notion, Arc Browser, Apple, and Vercel.