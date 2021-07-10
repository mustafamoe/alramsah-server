CREATE DATABASE alramsah;
\c alramsah

CREATE TABLE IF NOT EXISTS user_images (
    image_id uuid PRIMARY KEY NOT NULL,
    image_name VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO user_images (
    image_id,
    image_name
) VALUES ('e5daee20-3122-4481-9898-4682624fae09', 'prof.png');

CREATE TABLE IF NOT EXISTS users (
    user_id uuid PRIMARY KEY,
    avatar uuid REFERENCES user_images(image_id) ON UPDATE CASCADE,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(255) NOT NULL,
    version INT,
    password VARCHAR(255) NOT NULL,
    last_logged_in TIMESTAMPTZ DEFAULT NOW(),
    user_order SERIAL NOT NULL,
    is_super_admin BOOLEAN NOT NULL DEFAULT FALSE,
    is_admin BOOLEAN NOT NULL DEFAULT FALSE,
    is_editor BOOLEAN NOT NULL DEFAULT FALSE,
    is_reporter BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT FALSE,
    is_blocked BOOLEAN NOT NULL DEFAULT FALSE,
    updated_by uuid REFERENCES users(user_id),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE IF EXISTS user_images
    ADD COLUMN user_id uuid
    REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE IF NOT EXISTS images (
    image_id uuid PRIMARY KEY,
    sizes JSONB,
    image_description TEXT,
    created_by uuid NOT NULL REFERENCES users(user_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ALTER TABLE images ADD sizes JSONB;
-- ALTER TABLE images DROP COLUMN image_name;

CREATE TABLE IF NOT EXISTS files (
    file_id uuid PRIMARY KEY,
    text TEXT NOT NULL,
    image_id uuid REFERENCES images(image_id) ON UPDATE CASCADE,
    created_by uuid REFERENCES users(user_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    updated_by uuid REFERENCES users(user_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS sections (
    section_id uuid PRIMARY KEY,
    section_name TEXT NOT NULL,
    color VARCHAR(255),
    section_order SERIAL NOT NULL,
    is_archived BOOLEAN DEFAULT FALSE,
    created_by uuid REFERENCES users(user_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    updated_by uuid REFERENCES users(user_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ALTER TABLE sections
-- ADD section_order SERIAL NOT NULL;

-- UPDATE sections SET section_order=1 WHERE section_name='اقتصاد';
-- UPDATE sections SET section_order=2 WHERE section_name='تكنولوجيا';
-- UPDATE sections SET section_order=3 WHERE section_name='سياسة';
-- UPDATE sections SET section_order=4 WHERE section_name='ثقافة';
-- UPDATE sections SET section_order=5 WHERE section_name='رياضة';
-- UPDATE sections SET section_order=6 WHERE section_name='تحقيق';
-- UPDATE sections SET section_order=7 WHERE section_name='سياحة';
-- UPDATE sections SET section_order=8 WHERE section_name='منوعات';
-- UPDATE sections SET section_order=9 WHERE section_name='كتاب وآراء';

CREATE TABLE IF NOT EXISTS tags (
    tag_id uuid PRIMARY KEY,
    tag_name TEXT NOT NULL,
    tag_order SERIAL NOT NULL,
    created_by uuid REFERENCES users(user_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    updated_by uuid REFERENCES users(user_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS articles (
    article_id uuid PRIMARY KEY,
    thumbnail uuid REFERENCES images(image_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    intro TEXT,
    title TEXT NOT NULL,
    text TEXT NOT NULL,
    sub_titles JSONB NULL,
    section uuid REFERENCES sections(section_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    is_published BOOLEAN DEFAULT FALSE,
    readers INT,
    created_by uuid REFERENCES users(user_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    updated_by uuid REFERENCES users(user_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW() 
);

CREATE TABLE IF NOT EXISTS article_image (
    article_id uuid NOT NULL REFERENCES articles(article_id) ON DELETE CASCADE ON UPDATE CASCADE,
    image_id uuid NOT NULL REFERENCES images(image_id) ON UPDATE CASCADE,
    CONSTRAINT article_image_pkey PRIMARY KEY (article_id, image_id)
);

CREATE TABLE IF NOT EXISTS article_tag (
    article_id uuid NOT NULL REFERENCES articles(article_id) ON DELETE CASCADE ON UPDATE CASCADE,
    tag_id uuid NOT NULL REFERENCES tags(tag_id) ON UPDATE CASCADE,
    CONSTRAINT article_tag_pkey PRIMARY KEY (article_id, tag_id)
);

CREATE TABLE IF NOT EXISTS news (
    news_id uuid PRIMARY KEY,
    thumbnail uuid REFERENCES images(image_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    intro TEXT,
    title TEXT NOT NULL,
    text TEXT NOT NULL,
    sub_titles JSONB NULL,
    section uuid REFERENCES sections(section_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    readers INT,
    file uuid REFERENCES files(file_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    is_published BOOLEAN DEFAULT FALSE,
    is_archived BOOLEAN DEFAULT FALSE,
    created_by uuid REFERENCES users(user_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    updated_by uuid REFERENCES users(user_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ALTER TABLE news DROP COLUMN news_order;

-- ALTER TABLE news DROP COLUMN intro;
-- ALTER TABLE news ADD intro TEXT;

-- ALTER TABLE news ADD is_archived BOOLEAN DEFAULT FALSE;

-- ALTER TABLE news
-- ADD readers INT;

-- ALTER TABLE news
-- ADD thumbnail uuid REFERENCES images(image_id) ON DELETE NO ACTION ON UPDATE CASCADE;

-- ALTER TABLE news ADD file uuid REFERENCES files(file_id) ON DELETE NO ACTION ON UPDATE CASCADE;

CREATE TABLE IF NOT EXISTS news_image (
    news_id uuid NOT NULL REFERENCES news(news_id) ON DELETE CASCADE ON UPDATE CASCADE,
    image_id uuid NOT NULL REFERENCES images(image_id) ON UPDATE CASCADE,
    CONSTRAINT news_image_pkey PRIMARY KEY (news_id, image_id)
);

CREATE TABLE IF NOT EXISTS news_tag (
    news_id uuid NOT NULL REFERENCES news(news_id) ON DELETE CASCADE ON UPDATE CASCADE,
    tag_id uuid NOT NULL REFERENCES tags(tag_id) ON UPDATE CASCADE,
    CONSTRAINT news_tag_pkey PRIMARY KEY (news_id, tag_id)
);

CREATE TABLE IF NOT EXISTS strips (
    strip_id uuid PRIMARY KEY,
    title TEXT NOT NULL,
    link TEXT,
    duration VARCHAR(255) NOT NULL,
    type VARCHAR(255) NOT NULL,
    created_by uuid REFERENCES users(user_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    updated_by uuid REFERENCES users(user_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS messages (
    message_id uuid PRIMARY KEY,
    subject TEXT NOT NULL,
    text TEXT NOT NULL,
    to_user uuid REFERENCES users(user_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    is_viewed BOOLEAN DEFAULT FALSE,
    message_order SERIAL NOT NULL,
    created_by uuid REFERENCES users(user_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS message_image (
    message_id uuid NOT NULL REFERENCES messages(message_id) ON DELETE CASCADE ON UPDATE CASCADE,
    image_id uuid NOT NULL REFERENCES images(image_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT message_image_pkey PRIMARY KEY (message_id, image_id)
);

CREATE TABLE IF NOT EXISTS privacy_policy (
    privacy_policy_id BOOLEAN PRIMARY KEY DEFAULT TRUE,
    text TEXT NOT NULL,
    updated_by uuid REFERENCES users(user_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT privacy_policy_id CHECK (privacy_policy_id)
);

INSERT INTO privacy_policy (
    text
) VALUES ('');