-- Create Table
CREATE TABLE Sales (
    OrderId int,
    AppUserId int,
    Product varchar(10),
    Qty int
);

-- Populate with data
INSERT Sales VALUES
    (1, 1, 'Valve', 5),
    (2, 1, 'Wheel', 2),
    (3, 1, 'Valve', 4),
    (4, 2, 'Bracket', 2),
    (5, 2, 'Wheel', 5),
    (6, 2, 'Seat', 5);