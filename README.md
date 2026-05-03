**WEARN — Walk & Earn Platform**

_**У.Бямбаболор — Developer (Full-stack, system architecture)
Д.Маралмаа — Business & Finance**_

Wearn нь хэрэглэгчийн бодит алхалтыг урамшуулал болгон хувиргадаг mobile-first платформ юм.

Системийн үндсэн зарчим нь “алхалт → оноо → урамшуулал” гэсэн энгийн боловч үр дүнтэй урсгал дээр суурилдаг. 
Хэрэглэгч гар утсаараа алхалтын мэдээллээ автоматаар цуглуулж, тухайн өгөгдөл нь сервер талд баталгаажсаны дараа оноо болон хөрвөгдөж, 
улмаар merchant байгууллагуудын санал болгож буй урамшуулалд ашиглагдана.

Wearn систем нь хэд хэдэн үндсэн бүрэлдэхүүн хэсгээс бүрдэнэ. Mobile аппликейшн нь Flutter технологи дээр суурилан iOS болон Android төхөөрөмжүүдэд зориулан хөгжүүлэгдсэн бөгөөд HealthKit болон Health Connect 
интеграци ашиглан алхалтын өгөгдлийг найдвартайгаар авдаг. 
Backend хэсэг нь Node.js болон Express framework ашигласан REST API хэлбэрээр хэрэгжсэн бөгөөд JWT authentication, server-side validation болон fraud detection логик агуулдаг. 
Мөн React дээр суурилсан web dashboard нь админ болон merchant хэрэглэгчдэд зориулсан удирдлагын интерфейсийг бүрдүүлж, урамшуулал удирдах, хэрэглэгчийн мэдээлэл харах, статистик шинжлэх боломжийг олгодог. 
Бүх өгөгдөл MySQL мэдээллийн санд хадгалагдаж, ACID transaction зарчмаар найдвартай ажиллагааг хангадаг.

Энэхүү төслийн онцлог нь зөвхөн алхалт хэмжих биш, харин тухайн өгөгдлийг баталгаажуулж, бодит урамшууллын системтэй холбож өгсөнд оршино. 
Алхалтын өгөгдлийн үнэн зөв байдлыг хангах зорилгоор давтамж, хурд, хугацаа зэрэг параметрүүдийг шалгах сервер талын алгоритм ашигладаг бөгөөд хуурамч алхалт үүсгэх оролдлогыг илрүүлэх механизмыг мөн тусгасан.
Түүнчлэн reward олголтыг давхардахгүй байхаар ACID transaction ашиглан шийдсэн нь системийн найдвартай байдлыг нэмэгдүүлдэг.

Бизнесийн хувьд Wearn нь хэрэглэгч, merchant байгууллага болон компаниудыг холбосон олон талт экосистем бүрдүүлэхийг зорьж байна. Merchant байгууллагууд платформ дээр урамшуулал байршуулж хэрэглэгч татах боломжтой 
бол хэрэглэгчид өөрийн идэвхтэй хөдөлгөөнөөр дамжуулан бодит үнэ цэн бүхий урамшуулал авах боломжтой. Цаашид B2B чиглэлээр байгууллагуудад ажилчдын эрүүл мэндийг дэмжих шийдэл болгон хөгжүүлэх боломжтой.

Энэхүү төсөл нь эрүүл амьдралын хэв маягийг дэмжих, технологийг ашиглан хэрэглэгчийн зан төлөвт эерэг нөлөө үзүүлэх, мөн бизнесүүдэд шинэ маркетингийн суваг бий болгох зорилготой юм.



**Нэмэлт архитектурын онцлог**
| Модуль               | Хэрэгжүүлсэн зүйл                                   |
| -------------------- | --------------------------------------------------- |
| Authentication       | JWT (7d expiration) + bcrypt hashing                |
| Authorization        | Role-Based Access Control (USER / ADMIN / MERCHANT) |
| Transaction Handling | MySQL Transaction (BEGIN / COMMIT / ROLLBACK)       |
| Concurrency Control  | `SELECT ... FOR UPDATE` ашигласан                   |
| Fraud Detection      | Step delta validation + spike detection             |
| Analytics            | Daily stats, leaderboard, admin overview            |
| Time-Series Handling | Zero-day filling logic                              |
| Reverse Proxy        | Nginx → Docker backend proxy                        |
| Containerization     | Dockerized Node.js backend                          |
| CI/CD                | GitHub Actions → Docker Hub → Droplet auto deploy   |
| Security             | Firewall (80/443 allow, 5000 deny)                  |
| SSL                  | Let’s Encrypt HTTPS                                 |
| DB Security          | Managed MySQL + SSL required                        |
| Isolation            | Backend Docker container дотор ажиллана             |
