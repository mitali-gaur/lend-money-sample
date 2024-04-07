# lend-money-sample

## Getting Started

### Prerequisites

Make sure you have the following installed on your local machine:

- Ruby (version >= 3.1.2)
- Rails (version >= 7.0.8.1)
- SQLite

### Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/mitali-gaur/lend-money-sample.git
    ```

2. Bundle gems:

    ```bash
    bundle install
    ```

3. Setup database:

    ```bash
    rails db:create db:migrate db:seed
    ```

4. Start server:

    ```bash
    rails server
    ```

   Access admin at [http://localhost:3000/admin](http://localhost:3000/admin)

### Background jobs

Run Sidekiq for background jobs:

```bash
bundle exec sidekiq
