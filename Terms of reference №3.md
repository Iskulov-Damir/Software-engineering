## Description

Система доставки еды представляет собой онлайн-платформу, которая обеспечивает пользователей возможность заказа еды из различных ресторанов и доставку заказов курьерами. Она предоставляет удобный и эффективный способ для клиентов заказывать блюда из различных заведений, а также для ресторанов и курьеров эффективно управлять заказами и доставкой.

- **Регистрация и аутентификация**: Пользователи могут зарегистрироваться в системе как клиенты, рестораны или курьеры, указав необходимую информацию, такую как имя, адрес электронной почты и номер телефона. После регистрации они могут аутентифицироваться для доступа к своим аккаунтам.
- **Заказ еды**: Клиенты могут просматривать меню ресторанов, выбирать блюда и оформлять заказы через веб-интерфейс или мобильное приложение. Они могут указать адрес доставки и способ оплаты.
- **Управление заказами**: Рестораны получают уведомления о новых заказах и могут принимать или отклонять их. Они могут отслеживать статусы заказов и готовить блюда для доставки. Курьеры получают уведомления о заказах, которые им назначены, и могут подтверждать их доставку. Они могут отслеживать маршруты доставки и информировать клиентов о статусе доставки.
- **Оплата и оценка**: После доставки заказа клиент может оплатить его через платформу. Клиент также может оценить качество обслуживания и оставить отзыв о заказе.

## Use case diagram

```mermaid
flowchart LR
	Client(((Client)))
	Restaurant(((Restaurant)))
	Courier(((Courier)))
	
	subgraph "System"
	OrderFood{{Order food}}
	RateOrder{{Rate order}}
	AcceptOrder{{Accept order}}
	ManageMenu{{Manage menu}}
	DeliverOrder{{Deliver order}}
	end
	
	Client --- OrderFood
	Client --- RateOrder
	Restaurant --- AcceptOrder
	Restaurant --- ManageMenu
	Courier --- DeliverOrder
```

## Sequence diagram

```mermaid
sequenceDiagram
    participant Client
    participant System
    participant Restaurant
    participant Courier
	
	Client ->> System: Log in / Sign up
	System -->> Client: Confirm log in / sign up
	Client ->> System: Choose restaurant
	System -->> Client: Display menu
	Client ->> System: Select dishes and add to cart
	System -->> Client: Confirm adding to cart
	System ->> Client: Request delivery address
	Client -->> System: Enter delivery address
	System ->> Client: Request payment method
	Client -->> System: Enter payment method
	Client ->> System: Place order
	System -->> Client: Confirm order
	System ->> Restaurant: Send order details
	Restaurant -->> System: Confirm order
	System -->> Client: Order accepted
	Restaurant ->> System: Order ready for delivery
	System ->> Courier: Order ready for pickup
	Courier ->> Restaurant: Pick up order
	Courier ->> System: Confirm pickup
	System -->> Client: Out for delivery
	Courier ->> Client: Deliver order
	Client ->> System: Confirm delivery
	System -->> Client: Request order rating
	Client -->> System: Rate delivery

```


## State diagram

```mermaid
stateDiagram
	OrderPlaced: Order placed by client
    OrderConfirmed: Order confirmed by restaurant
    OrderPrepared: Order prepared by restaurant
    OutForDelivery: Order picked up by courier
    Delivered: Order delivered to client
    Rated: Order rated by client
	
    [*] --> OrderPlaced
    OrderPlaced --> OrderConfirmed: Confirm order
    OrderConfirmed --> OrderPrepared: Prepare order
    OrderPrepared --> OutForDelivery: Pick up order
    OutForDelivery --> Delivered: Deliver order
    Delivered --> Rated: Rate order
    Rated --> [*]
```

## Activity diagram

```mermaid
stateDiagram
	state is_valid_order <<choice>>
	state is_available_courier <<choice>>
	state is_delivered <<choice>>
	state is_paid <<choice>>
	
	ReceiveOrder: Receive order
	SendOrderDetails: Send order details
	RestaurantRejected: Restaurant rejected
	NotifyClientRejection: Notify client rejection
	RestaurantConfirm: Restaurant confirm
	MonitorPreparation: Monitor preparation
	TrackPreparation: Track preparation
	PreparationComplete: Preparation complete
	SendPickupRequest: Send pickup request
	CourierAssigned: Courier assigned
	NotifyClientCourierUnavailable: Notify client courier unavailable
	MonitorDelivery: Monitor delivery
	OutForDelivery: Out for delivery
	DeliveryComplete: Delivery complete
	ConfirmDelivery: Confirm delivery
	NotifyClientDeliveryFailed: Notify client delivery failed
	DeliveryFails: Delivery fails
	PaymentDetails: Payment details
	PaymentProcessing: Payment processing
	PaymentComplete: Payment complete 
	PaymentFails: Payment fails
	RequestRating: Request rating
	SendRatingRequest: Send rating request
	ReceiveRating: Receive rating
	
	[*] --> ReceiveOrder
	ReceiveOrder --> SendOrderDetails
	SendOrderDetails --> is_valid_order
	is_valid_order --> RestaurantRejected: If invalid order
	RestaurantRejected --> NotifyClientRejection
	NotifyClientRejection --> [*]
	is_valid_order --> RestaurantConfirm: If invalid order
	RestaurantConfirm --> MonitorPreparation
	state MonitorPreparation {
		direction LR
		[*] --> TrackPreparation
		TrackPreparation --> PreparationComplete
		PreparationComplete --> [*]
	}
	MonitorPreparation --> SendPickupRequest
	SendPickupRequest --> is_available_courier
	is_available_courier --> CourierAssigned: If courier is available
	is_available_courier --> NotifyClientCourierUnavailable: If courier is unavailable
	NotifyClientCourierUnavailable --> SendPickupRequest
	CourierAssigned --> MonitorDelivery
	state MonitorDelivery {
		direction LR
		[*] --> OutForDelivery
		OutForDelivery --> DeliveryFails
		DeliveryFails --> [*]
		OutForDelivery --> DeliveryComplete
		DeliveryComplete --> ConfirmDelivery
		ConfirmDelivery --> [*]
	}
	MonitorDelivery --> is_delivered
	is_delivered --> NotifyClientDeliveryFailed: If not delivered
	NotifyClientDeliveryFailed --> [*]
	is_delivered --> Payment: If delivered
	state Payment {
		direction LR
		[*] --> PaymentDetails
		PaymentDetails --> PaymentProcessing
		PaymentProcessing --> PaymentFails
		PaymentFails --> [*]
		PaymentProcessing --> PaymentComplete
		PaymentComplete --> [*] 
	}
	Payment --> is_paid
	is_paid --> Payment: If not paid
	is_paid --> RequestRating: If paid
	state RequestRating {
		direction LR
		[*] --> SendRatingRequest
		SendRatingRequest --> ReceiveRating
		ReceiveRating --> [*]
	}
	RequestRating --> [*]
```

## Class diagram

```mermaid
classDiagram
    class Client {
        +ID: int
        +Name: string
        +Mail: string
        +Phone: string
        +Password: string
        +Adress: string
        Order(RestaurantID: int, Items: list)
        Rate(OrderID: int, rating: int)
    }
	
	class Courier {
		+ID: int
        +Name: string
        +Mail: string
        +Phone: string
        +Password: string
        +Deliver(orderID: int)
    }
	
    class Restaurant {
        +ID: int
        +Name: string
        +Mail: string
        +Phone: string
        +Password: string
        +Adress: string
        +Menu: List<Item>
        +Accept(orderID: int)
    }

    class Item {
        +ID: int
        +RestaurantID: int
        +Name: string
        +Description: string
        +Price: float
    }

    class Order {
        +ID: int
        +ClientID: int
        +CourierID: int
        +RestaurantID: int
        +Date: date
        +Amout: float
        +Status string
    }
    
    Client "+1" -- "+0..*" Order
    Client "+1" -- "+0..*" Item
    Courier "+1" -- "+0..*" Order
    Restaurant "+1" -- "+0..*" Order
    Restaurant "+1" -- "+0..*" Item
```
