DECLARE
    CURSOR cur IS SELECT * FROM Customer;
BEGIN
    FOR rec IN cur LOOP
        dbms_output.put_line('Customers Details: ID: '
                            ||rec.Customer_id
                            ||' Name: '||rec.Customer_Name
                            ||' Telephone: '||rec.Customer_Tel);
    END LOOP;
END;
/




CREATE OR REPLACE PS_Customer_Prodcut (v_customer_id Customer.Customer_id%TYPE) IS
CURSOR cur IS
SELECT Product_Name
FROM Orders
INNER JOIN Customer ON Orders.Customer_id = Customer.Customer_id
INNER JOIN Product ON Orders.Product_id = Product.Product_id
WHERE v_customer_id = Customer_id;
BEGIN
FOR rec IN cur LOOP
dbms_output.put_line('Products: '||rec.Product_Name);
END LOOP;
EXCEPTION
WHEN NO_DATA_FOUND THEN
dbms_output.put_line('No products returned or customer not found');
END;
/



CREATE OR REPLACE FUNCTION FN_Customer_Orders(v_customer_id Orders.Customer_id%TYPE)
RETURN NUMBER IS nb_orders := 0;
BEGIN
SELECT COUNT(*) 
INTO nb_orders 
FROM Orders
WHERE Orders.Customer_id = v_cutomer_id;
dbms_output.put_line(nb_orders);
END;
/



CREATE OR REPLACE TRIGGER TRIG_INS_ORDERS
BEFORE INSERT ON Orders FOR EACH ROW
BEGIN
IF(:old.OrderDate >= SYSDATE) THEN
RAISE_APPLICATION_ERROR (-20567 ,"Order Date must be greater than or equal to today's date");
END IF;
END;
/