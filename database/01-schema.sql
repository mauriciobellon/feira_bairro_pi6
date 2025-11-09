-- ============================================
-- Feira do Bairro Database Schema
-- PostgreSQL Database Structure
-- Univesp PI6 - Campo Limpo Paulista
-- ============================================

-- Drop existing tables (in reverse order of dependencies)
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS product_images CASCADE;
DROP TABLE IF EXISTS ask_requests CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- ============================================
-- Table: users
-- Stores sellers and buyers information
-- ============================================
CREATE TABLE users (
    id VARCHAR(50) PRIMARY KEY,
    display_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    password TEXT NOT NULL,

    -- User type: buyer, seller, or both
    user_type VARCHAR(20) DEFAULT 'buyer' CHECK (user_type IN ('buyer', 'seller', 'both')),

    -- Seller-specific fields (only relevant when user_type is 'seller' or 'both')
    rating DECIMAL(2,1) DEFAULT 0.0 CHECK (rating >= 0 AND rating <= 5),
    total_sales INTEGER DEFAULT 0,

    -- Buyer-specific fields (optional, for future use)
    total_purchases INTEGER DEFAULT 0,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Table: categories
-- Product categories
-- ============================================
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image_url TEXT,
    popular BOOLEAN DEFAULT false,
    item_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Table: products
-- Main product listings
-- ============================================
CREATE TABLE products (
    id VARCHAR(50) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category_id INTEGER NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
    seller_id VARCHAR(50) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Condition: novo, como-novo, muito-bom, bom, regular
    condition VARCHAR(20) NOT NULL CHECK (condition IN ('novo', 'como-novo', 'muito-bom', 'bom', 'regular')),
    
    -- Price in BRL (Brazilian Real)
    price_brl DECIMAL(10,2) NOT NULL CHECK (price_brl >= 0),
    negotiable BOOLEAN DEFAULT false,
    
    -- Location information
    zip_code VARCHAR(10),
    city VARCHAR(100),
    state VARCHAR(2),
    country VARCHAR(2) DEFAULT 'BR',
    
    -- Status: active, sold, inactive
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'sold', 'inactive')),
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Table: product_images
-- Product images (multiple per product)
-- ============================================
CREATE TABLE product_images (
    id SERIAL PRIMARY KEY,
    product_id VARCHAR(50) NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    url TEXT NOT NULL,
    alt_text VARCHAR(255),
    is_cover BOOLEAN DEFAULT false,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Table: reviews
-- Vendor/seller reviews
-- ============================================
CREATE TABLE reviews (
    id VARCHAR(50) PRIMARY KEY,
    seller_id VARCHAR(50) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    reviewer_name VARCHAR(100) NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Table: ask_requests
-- "Ask Out" feature - users requesting items
-- ============================================
CREATE TABLE ask_requests (
    id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    budget DECIMAL(10,2) CHECK (budget >= 0),
    is_donation BOOLEAN DEFAULT false,
    requester_name VARCHAR(100),
    requester_email VARCHAR(255),
    requester_phone VARCHAR(20),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'matched', 'closed')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Indexes for better query performance
-- ============================================
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_seller ON products(seller_id);
CREATE INDEX idx_products_status ON products(status);
CREATE INDEX idx_products_created ON products(created_at DESC);
CREATE INDEX idx_product_images_product ON product_images(product_id);
CREATE INDEX idx_reviews_seller ON reviews(seller_id);
CREATE INDEX idx_ask_requests_status ON ask_requests(status);
CREATE INDEX idx_ask_requests_created ON ask_requests(created_at DESC);

