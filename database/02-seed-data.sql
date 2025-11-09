-- ============================================
-- Feira do Bairro Database Seed Data
-- Sample data for development and testing
-- Univesp PI6 - Campo Limpo Paulista
-- ============================================
-- This file is NOT for version control
-- Run after schema.sql to populate database
-- ============================================

-- ============================================
-- Insert sample categories (only if not exists)
-- ============================================
INSERT INTO categories (id, name, description, image_url, popular, item_count)
SELECT 1, 'Eletrônicos', 'Smartphones, laptops, tablets e mais', 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=300&h=200&fit=crop', true, 500
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 1);

INSERT INTO categories (id, name, description, image_url, popular, item_count)
SELECT 2, 'Casa, Decoração e Utensílios', 'Móveis, decoração e utensílios domésticos', 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=300&h=200&fit=crop', true, 200
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 2);

INSERT INTO categories (id, name, description, image_url, popular, item_count)
SELECT 3, 'Artigos Infantis', 'Brinquedos, roupas e acessórios infantis', 'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=300&h=200&fit=crop', true, 150
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 3);

INSERT INTO categories (id, name, description, image_url, popular, item_count)
SELECT 4, 'Escritório', 'Material de escritório e estudo', 'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?w=300&h=200&fit=crop', true, 300
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 4);

INSERT INTO categories (id, name, description, image_url, popular, item_count)
SELECT 5, 'Animais de Estimação', 'Acessórios e produtos para pets', 'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=300&h=200&fit=crop', true, 100
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 5);

INSERT INTO categories (id, name, description, image_url, popular, item_count)
SELECT 6, 'Roupas', 'Moda masculina e feminina', 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=300&h=200&fit=crop', false, 0
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 6);

INSERT INTO categories (id, name, description, image_url, popular, item_count)
SELECT 7, 'Calçados', 'Tênis, sapatos e sandálias', 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=300&h=200&fit=crop', false, 0
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 7);

INSERT INTO categories (id, name, description, image_url, popular, item_count)
SELECT 8, 'Relógios', 'Relógios de pulso e smartwatches', 'https://images.unsplash.com/photo-1524592094714-0f0654e20314?w=300&h=200&fit=crop', false, 0
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 8);

INSERT INTO categories (id, name, description, image_url, popular, item_count)
SELECT 9, 'Livros', 'Livros acadêmicos e literatura', 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=300&h=200&fit=crop', false, 0
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 9);

INSERT INTO categories (id, name, description, image_url, popular, item_count)
SELECT 10, 'Esportes', 'Equipamentos esportivos', 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=200&fit=crop', false, 0
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 10);

INSERT INTO categories (id, name, description, image_url, popular, item_count)
SELECT 11, 'Instrumentos Musicais', 'Violões, teclados e mais', 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=200&fit=crop', false, 0
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 11);

INSERT INTO categories (id, name, description, image_url, popular, item_count)
SELECT 12, 'Outros', 'Diversos itens', 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=300&h=200&fit=crop', false, 0
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 12);

-- ============================================
-- Insert sample users - only if not exists
-- ============================================
-- Sellers
INSERT INTO users (id, display_name, email, password, user_type, rating, total_sales)
SELECT 'u-001', 'Marcos', 'marcos@example.com', '1234', 'seller', 4.8, 23
WHERE NOT EXISTS (SELECT 1 FROM users WHERE id = 'u-001');

INSERT INTO users (id, display_name, email, password, user_type, rating, total_sales)
SELECT 'u-002', 'Ana', 'ana@example.com', '1234', 'seller', 4.9, 41
WHERE NOT EXISTS (SELECT 1 FROM users WHERE id = 'u-002');

INSERT INTO users (id, display_name, email, password, user_type, rating, total_sales)
SELECT 'u-003', 'Júlia', 'julia@example.com', '1234', 'seller', 4.6, 12
WHERE NOT EXISTS (SELECT 1 FROM users WHERE id = 'u-003');

-- Buyers (examples)
INSERT INTO users (id, display_name, email, password, user_type, total_purchases)
SELECT 'u-101', 'Carlos Souza', 'carlos@example.com', '1234', 'buyer', 5
WHERE NOT EXISTS (SELECT 1 FROM users WHERE id = 'u-101');

INSERT INTO users (id, display_name, email, password, user_type, total_purchases)
SELECT 'u-102', 'Maria Santos', 'maria@example.com', '1234', 'buyer', 3
WHERE NOT EXISTS (SELECT 1 FROM users WHERE id = 'u-102');

-- Users who are both buyers and sellers
INSERT INTO users (id, display_name, email, password, user_type, rating, total_sales, total_purchases)
SELECT 'u-201', 'Pedro Lima', 'pedro@example.com', '1234', 'both', 4.7, 8, 12
WHERE NOT EXISTS (SELECT 1 FROM users WHERE id = 'u-201');

-- ============================================
-- Insert sample products - only if not exists
-- ============================================
INSERT INTO products (id, title, description, category_id, seller_id, condition, price_brl, negotiable, zip_code, city, state, country)
SELECT 'p-iph-13-128-azul', 'iPhone 13 Pro 128GB Azul', 'iPhone 13 Pro em excelente estado, acompanha caixa e carregador. Bateria com 90% de saúde.', 1, 'u-001', 'como-novo', 4999.90, true, '01001-000', 'São Paulo', 'SP', 'BR'
WHERE NOT EXISTS (SELECT 1 FROM products WHERE id = 'p-iph-13-128-azul');

INSERT INTO products (id, title, description, category_id, seller_id, condition, price_brl, negotiable, zip_code, city, state, country)
SELECT 'p-mac-2019-16', 'MacBook Pro 16"', 'MacBook Pro 16 (2019) com i9, 16GB RAM, 1TB SSD. Pequenos sinais de uso.', 1, 'u-002', 'muito-bom', 8999.00, false, '20010-000', 'Rio de Janeiro', 'RJ', 'BR'
WHERE NOT EXISTS (SELECT 1 FROM products WHERE id = 'p-mac-2019-16');

INSERT INTO products (id, title, description, category_id, seller_id, condition, price_brl, negotiable, zip_code, city, state, country)
SELECT 'p-cafeteira-espresso', 'Cafeteira Espresso', 'Cafeteira semiautomática pouco usada, inclui filtros e manual.', 2, 'u-003', 'bom', 450.00, true, '30110-000', 'Belo Horizonte', 'MG', 'BR'
WHERE NOT EXISTS (SELECT 1 FROM products WHERE id = 'p-cafeteira-espresso');

-- ============================================
-- Insert sample product images - only if not exists
-- ============================================
INSERT INTO product_images (product_id, url, alt_text, is_cover, display_order)
SELECT 'p-iph-13-128-azul', 'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?w=800', 'iPhone 13 Pro azul', true, 1
WHERE NOT EXISTS (SELECT 1 FROM product_images WHERE product_id = 'p-iph-13-128-azul' AND display_order = 1);

INSERT INTO product_images (product_id, url, alt_text, is_cover, display_order)
SELECT 'p-iph-13-128-azul', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800', 'iPhone 13 Pro traseira', false, 2
WHERE NOT EXISTS (SELECT 1 FROM product_images WHERE product_id = 'p-iph-13-128-azul' AND display_order = 2);

INSERT INTO product_images (product_id, url, alt_text, is_cover, display_order)
SELECT 'p-mac-2019-16', 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800', 'MacBook Pro 16"', true, 1
WHERE NOT EXISTS (SELECT 1 FROM product_images WHERE product_id = 'p-mac-2019-16' AND display_order = 1);

INSERT INTO product_images (product_id, url, alt_text, is_cover, display_order)
SELECT 'p-cafeteira-espresso', 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800', 'Cafeteira Espresso', true, 1
WHERE NOT EXISTS (SELECT 1 FROM product_images WHERE product_id = 'p-cafeteira-espresso' AND display_order = 1);

-- ============================================
-- Insert sample reviews - only if not exists
-- ============================================
INSERT INTO reviews (id, seller_id, reviewer_name, rating, comment)
SELECT 'r1', 'u-001', 'Koushik D.', 5, 'Serviço incrível... muito satisfeito com eles.'
WHERE NOT EXISTS (SELECT 1 FROM reviews WHERE id = 'r1');

INSERT INTO reviews (id, seller_id, reviewer_name, rating, comment)
SELECT 'r2', 'u-002', 'Rizwan K.', 5, 'Processo foi tranquilo e rápido. Estou muito feliz com o serviço. Altamente recomendado.'
WHERE NOT EXISTS (SELECT 1 FROM reviews WHERE id = 'r2');

INSERT INTO reviews (id, seller_id, reviewer_name, rating, comment)
SELECT 'r3', 'u-002', 'Priyanka E.', 5, 'Entrega foi rápida. Embalagem também estava muito boa.'
WHERE NOT EXISTS (SELECT 1 FROM reviews WHERE id = 'r3');

INSERT INTO reviews (id, seller_id, reviewer_name, rating, comment)
SELECT 'r4', 'u-001', 'Marina S.', 5, 'Produto como descrito, atendimento excelente!'
WHERE NOT EXISTS (SELECT 1 FROM reviews WHERE id = 'r4');

INSERT INTO reviews (id, seller_id, reviewer_name, rating, comment)
SELECT 'r5', 'u-003', 'Carlos A.', 5, 'Chegou rapidinho, recomendo.'
WHERE NOT EXISTS (SELECT 1 FROM reviews WHERE id = 'r5');

-- ============================================
-- Insert sample ask requests - only if not exists
-- ============================================
INSERT INTO ask_requests (id, product_name, budget, is_donation)
SELECT 'a1', 'Cadeira ergonômica', 350.00, false
WHERE NOT EXISTS (SELECT 1 FROM ask_requests WHERE id = 'a1');

INSERT INTO ask_requests (id, product_name, budget, is_donation)
SELECT 'a2', 'Livro Cálculo I', NULL, true
WHERE NOT EXISTS (SELECT 1 FROM ask_requests WHERE id = 'a2');

INSERT INTO ask_requests (id, product_name, budget, is_donation)
SELECT 'a3', 'iPhone 11', 1800.00, false
WHERE NOT EXISTS (SELECT 1 FROM ask_requests WHERE id = 'a3');

INSERT INTO ask_requests (id, product_name, budget, is_donation)
SELECT 'a4', 'Fogão 4 bocas', 600.00, false
WHERE NOT EXISTS (SELECT 1 FROM ask_requests WHERE id = 'a4');

INSERT INTO ask_requests (id, product_name, budget, is_donation)
SELECT 'a5', 'Mochila para notebook', 120.00, false
WHERE NOT EXISTS (SELECT 1 FROM ask_requests WHERE id = 'a5');

INSERT INTO ask_requests (id, product_name, budget, is_donation)
SELECT 'a6', 'Roupas infantis', NULL, true
WHERE NOT EXISTS (SELECT 1 FROM ask_requests WHERE id = 'a6');
