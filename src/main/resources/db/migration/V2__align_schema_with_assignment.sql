
-- V2: Align the existing schema with the IPT Tracker assignment.
-- IMPORTANT: This migration assumes V1 has been applied
-- and V2 has NOT been applied before.

-- =====================================================
-- 1. USERS
-- =====================================================

ALTER TABLE users
    RENAME COLUMN enabled TO active;

ALTER TABLE users
    ADD COLUMN IF NOT EXISTS phone VARCHAR(30);

ALTER TABLE users
    ADD COLUMN IF NOT EXISTS registration_number VARCHAR(50);

CREATE UNIQUE INDEX IF NOT EXISTS uq_users_registration_number
    ON users (registration_number)
    WHERE registration_number IS NOT NULL;


-- =====================================================
-- 2. ORGANISATIONS
-- =====================================================

ALTER TABLE organisations
    ADD COLUMN IF NOT EXISTS sector VARCHAR(100);

ALTER TABLE organisations
    ADD COLUMN IF NOT EXISTS region VARCHAR(100);


-- =====================================================
-- 3. PLACEMENTS
-- =====================================================

ALTER TABLE placements
    ADD COLUMN IF NOT EXISTS department VARCHAR(100);

UPDATE placements
SET department = 'General'
WHERE department IS NULL;

ALTER TABLE placements
    ALTER COLUMN department SET NOT NULL;

ALTER TABLE placements
    ADD COLUMN IF NOT EXISTS status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE';

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'chk_placements_status'
          AND conrelid = 'placements'::regclass
    ) THEN
        ALTER TABLE placements
            ADD CONSTRAINT chk_placements_status
            CHECK (status IN ('ACTIVE', 'COMPLETED', 'CANCELLED'));
    END IF;
END $$;


-- =====================================================
-- 4. LOGBOOK ENTRIES
-- =====================================================

ALTER TABLE logbook_entries
    RENAME COLUMN title TO tasks_done;

ALTER TABLE logbook_entries
    RENAME COLUMN activities TO skills_learned;

ALTER TABLE logbook_entries
    DROP CONSTRAINT IF EXISTS fk_logbook_student;

ALTER TABLE logbook_entries
    DROP CONSTRAINT IF EXISTS uq_logbook_student_date;

ALTER TABLE logbook_entries
    DROP COLUMN student_id;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'uq_logbook_placement_date'
          AND conrelid = 'logbook_entries'::regclass
    ) THEN
        ALTER TABLE logbook_entries
            ADD CONSTRAINT uq_logbook_placement_date
            UNIQUE (placement_id, entry_date);
    END IF;
END $$;


-- =====================================================
-- 5. ASSESSMENTS
-- =====================================================

ALTER TABLE assessments
    RENAME COLUMN academic_supervisor_id TO assessor_id;

ALTER TABLE assessments
    RENAME COLUMN feedback TO remarks;

ALTER TABLE assessments
    ADD COLUMN IF NOT EXISTS visit_date DATE;

UPDATE assessments
SET visit_date = COALESCE(
    assessed_at::date,
    created_at::date,
    CURRENT_DATE
)
WHERE visit_date IS NULL;

ALTER TABLE assessments
    ALTER COLUMN visit_date SET NOT NULL;

ALTER TABLE assessments
    DROP CONSTRAINT IF EXISTS fk_assessments_academic_supervisor;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_assessments_assessor'
          AND conrelid = 'assessments'::regclass
    ) THEN
        ALTER TABLE assessments
            ADD CONSTRAINT fk_assessments_assessor
            FOREIGN KEY (assessor_id) REFERENCES users(id);
    END IF;
END $$;

-- Score is intentionally allowed to remain NULL for existing
-- assessments that have not yet been scored.
-- Application validation should restrict supplied scores to 0-100.
