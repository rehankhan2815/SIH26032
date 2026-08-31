# SIH26032 Database

## Database

- Database: PostgreSQL
- Version: PostgreSQL 18
- Database name: `sih26032`

## Purpose

Database for the Farmer Procurement Status Portal.

The database supports:

- Farmer management
- Procurement centers
- Crop management
- Procurement slots
- Slot booking
- Queue tracking
- Crop submission tracking
- Status history
- Notifications
- Commodity prices

---

## Tables

### 1. users

Stores authentication and user roles.

Important fields:

- `user_id` - Primary Key
- `full_name`
- `phone`
- `password_hash`
- `role` - FARMER / ADMIN
- `is_active`

---

### 2. farmer_profiles

Stores farmer-specific information.

Important fields:

- `farmer_id` - Primary Key
- `user_id` - Foreign Key → users
- `village`
- `district`
- `state`
- `address`

Relationship:

`users 1 → 1 farmer_profiles`

---

### 3. procurement_centers

Stores procurement center information.

Important fields:

- `center_id` - Primary Key
- `center_name`
- `address`
- `village`
- `district`
- `state`
- `contact_phone`
- `opening_time`
- `closing_time`

---

### 4. crops

Stores supported crops.

Important fields:

- `crop_id` - Primary Key
- `crop_name`
- `crop_code`
- `unit`
- `is_active`

---

### 5. procurement_slots

Stores available procurement slots.

Important fields:

- `slot_id` - Primary Key
- `center_id` - Foreign Key → procurement_centers
- `crop_id` - Foreign Key → crops
- `slot_date`
- `start_time`
- `end_time`
- `capacity`
- `booked_count`

---

### 6. bookings

Stores farmer slot bookings and queue information.

Important fields:

- `booking_id` - Primary Key
- `farmer_id` - Foreign Key → farmer_profiles
- `slot_id` - Foreign Key → procurement_slots
- `quantity`
- `queue_position`
- `estimated_wait_minutes`
- `booking_status`
- `booked_at`

---

### 7. crop_submissions

Tracks the farmer's crop after booking.

Possible statuses:

`RECEIVED`

→ `QUALITY_CHECKED`

→ `ACCEPTED` / `REJECTED`

→ `PAYMENT_PROCESSING`

→ `PAID`

Important fields:

- `submission_id` - Primary Key
- `booking_id` - Foreign Key → bookings
- `actual_quantity`
- `submission_status`
- `quality_notes`
- `rejection_reason`
- `payment_status`
- `payment_reference`

---

### 8. status_history

Stores every status change.

Important fields:

- `history_id` - Primary Key
- `submission_id` - Foreign Key → crop_submissions
- `old_status`
- `new_status`
- `changed_by` - Foreign Key → users
- `remarks`
- `changed_at`

---

### 9. notifications

Stores notifications for farmers/admins.

Important fields:

- `notification_id` - Primary Key
- `user_id` - Foreign Key → users
- `title`
- `message`
- `notification_type`
- `is_read`
- `created_at`

---

### 10. commodity_prices

Stores commodity market-price information.

Important fields:

- `price_id` - Primary Key
- `crop_id` - Foreign Key → crops
- `market_name`
- `district`
- `state`
- `price_date`
- `min_price`
- `max_price`
- `modal_price`
- `source`

---

# Main Relationships

```text
users
   │
   └── farmer_profiles
          │
          └── bookings
                 │
                 └── procurement_slots
                        │
                        ├── procurement_centers
                        │
                        └── crops

bookings
   │
   └── crop_submissions
          │
          └── status_history

users
   │
   └── notifications

crops
   │
   └── commodity_prices