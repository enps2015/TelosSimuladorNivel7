1- Análise exploratória

	-- listando todas as tabelas
	SELECT TABLE_NAME 
	FROM KCC.INFORMATION_SCHEMA.TABLES
	WHERE TABLE_TYPE = 'BASE TABLE';

	
	-- Listando as colunas de todas as tabelas
	SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE
	FROM KCC.INFORMATION_SCHEMA.COLUMNS;
	
	
	--Contando o número de registros em cada tabela
	SELECT 'Customers' AS TableName, COUNT(*) AS TotalRecords FROM KCC.dbo.Customers
	UNION ALL
	SELECT 'Orders', COUNT(*) FROM KCC.dbo.Orders
	UNION ALL
	SELECT 'Order_Product', COUNT(*) FROM KCC.dbo.Order_Product
	UNION ALL
	SELECT 'Product', COUNT(*) FROM KCC.dbo.Product;	
	
	
	--Analisando a tabela Custumers
	SELECT * FROM KCC.dbo.Customers;
	
	
	--Analisando as cidades, estados e países distintos da tabela Customers
	SELECT 
	    DISTINCT City, 
	    State, 
	    Country
	FROM 
	    KCC.dbo.Customers
	ORDER BY 
	    Country, State, City;

	
	--Analisando a tabela Orders
	SELECT * FROM KCC.dbo.Orders;
	
	
	--Distribuição de pedidos por mês
	SELECT 
	    MONTH(OrderDate) AS Month,                  
	    COUNT(*) AS TotalOrders,                    
	    SUM(OrderTotal) AS TotalRevenue             
	FROM 
	    KCC.dbo.Orders
	GROUP BY 
	    MONTH(OrderDate)                           
	ORDER BY 
	    Month;      
	    
	
	--Analisando a tabela Order_Product
	SELECT * FROM KCC.dbo.Order_Product;
	
	
	--Analisando a tabela Product
	SELECT * FROM KCC.dbo.Product;
	
	
	--Estatísticas descritivas para os valores numéricos
	--Tabela Orders - Variável: OrderTotal
	SELECT 
	    MIN(OrderTotal) AS MinOrderTotal,
	    MAX(OrderTotal) AS MaxOrderTotal,
	    AVG(OrderTotal) AS AvgOrderTotal,
	    SUM(OrderTotal) AS TotalOrderValue,
	    STDEV(OrderTotal) AS StdDevOrderTotal
	FROM KCC.dbo.Orders;
	
	
	--Estatísticas descritivas para os valores numéricos
	--Tabela Order_Product - Variável: Quantity
	SELECT 
	    MIN(Quantity) AS MinQuantity,
	    MAX(Quantity) AS MaxQuantity,
	    AVG(Quantity) AS AvgQuantity,
	    SUM(Quantity) AS TotalQuantitySold,
	    STDEV(Quantity) AS StdDevQuantity
	FROM KCC.dbo.Order_Product;
	
	
	--Estatísticas descritivas para os valores numéricos
	--Tabela Product - Variáveis: RevenuePerCookie
	SELECT 
	    MIN(RevenuePerCookie) AS MinRevenue,
	    MAX(RevenuePerCookie) AS MaxRevenue,
	    AVG(RevenuePerCookie) AS AvgRevenue,
	    SUM(RevenuePerCookie) AS TotalRevenue,
	    STDEV(RevenuePerCookie) AS StdDevRevenue
	FROM KCC.dbo.Product;


	--Tabela Product - Variáveis: CostPerCookie
	SELECT 
	    MIN(CostPerCookie) AS MinCost,
	    MAX(CostPerCookie) AS MaxCost,
	    AVG(CostPerCookie) AS AvgCost,
	    SUM(CostPerCookie) AS TotalCost,
	    STDEV(CostPerCookie) AS StdDevCost
	FROM KCC.dbo.Product;
	
	
2- Respondendo as Perguntas de Negócios - Pergunta 1: Quem são os 3 melhores clientes da empresa e por quê?

	-- Selecionando os 3 melhores clientes de acordo com o total de gastos
	SELECT TOP 3 
	    C.CustomerID, 
	    C.CustomerName, 
	    SUM(O.OrderTotal) AS TotalSpent,
	    COUNT(O.OrderID) AS TotalOrders
	FROM KCC.dbo.Customers C
	INNER JOIN KCC.dbo.Orders O ON C.CustomerID = O.CustomerID
	GROUP BY C.CustomerID, C.CustomerName
	ORDER BY TotalSpent DESC;
	
3- Respondendo as Perguntas de Negócios - Pergunta 2: Quais são os melhores e piores produtos da empresa?

	
	-- Identificando os produtos mais vendidos pelo soma das quantidades (Quantity)
	SELECT TOP 6 
	    P.CookieID, 
	    P.CookieName, 
	    SUM(OP.Quantity) AS TotalSold
	FROM KCC.dbo.Product P
	INNER JOIN KCC.dbo.Order_Product OP ON P.CookieID = OP.CookieID
	GROUP BY P.CookieID, P.CookieName
	ORDER BY TotalSold DESC;


	-- Identificando os produtos menos vendidos
	SELECT TOP 6 
	    P.CookieID, 
	    P.CookieName, 
	    SUM(OP.Quantity) AS TotalSold
	FROM KCC.dbo.Product P
	INNER JOIN KCC.dbo.Order_Product OP ON P.CookieID = OP.CookieID
	GROUP BY P.CookieID, P.CookieName
	ORDER BY TotalSold ASC;


4- Respondendo as Perguntas de Negócios - Pergunta 3: Existe sazonalidade nas vendas?



	-- Analisando a distribuição de pedidos por mês e valor total arrecadado
	SELECT 
	    MONTH(OrderDate) AS Month, 
	    COUNT(OrderID) AS TotalOrders, 
	    SUM(OrderTotal) AS TotalRevenue
	FROM KCC.dbo.Orders
	GROUP BY MONTH(OrderDate)
	ORDER BY Month;


5 - Respondendo as Perguntas de Negócios - Pergunta 4: Quais produtos devem ter aumento de preço e qual seria o novo preço?

	-- Recomendando produtos com base no custo e na receita por unidades vendidas
	SELECT 
	    P.CookieID, 
	    P.CookieName, 
	    SUM(OP.Quantity) AS TotalSold, 
	    P.RevenuePerCookie, 
	    P.CostPerCookie,
	    (P.RevenuePerCookie - P.CostPerCookie) AS ProfitPerUnit,
	    SUM(OP.Quantity) * (P.RevenuePerCookie - P.CostPerCookie) AS TotalProfit
	FROM KCC.dbo.Product P
	INNER JOIN KCC.dbo.Order_Product OP ON P.CookieID = OP.CookieID
	GROUP BY P.CookieID, P.CookieName, P.RevenuePerCookie, P.CostPerCookie
	ORDER BY TotalProfit DESC;

