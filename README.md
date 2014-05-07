<<<<<<< HEAD
## 支付宝{双功能接口}示范程序

power by sinatra, gem with alipay_dualfun

### ROUTE

```
  #transactions
  /transactions/done
  /transactions/notify
  /transactions/checkout

### USAGE

```
# start up
bundle install
thin start

# test with Test::Unit
ruby test/functional/transactions_controller_test.rb
# test with RSpec
rspec spec/controller/transactions_controller_spec.rb

# when add new coffeescript in assets/coffeescripts
# rake this task then generate js file in assets/javascripts 
rake coffeescript:complie
```

### nginx configure

```
server {
  listen 80;
  server_name alipay.d.solife.us;
  root /my-demo-path/public;
  passenger_enabled on;
  rails_env development;

  location /static {
    index index.html;
  }
}
```



### Code Statistics

``` 
rake stats
+----------------------+-------+-------+---------+---------+-----+-------+
| Name                 | Lines | LOC   | Classes | Methods | M/C | LOC/M |
+----------------------+-------+-------+---------+---------+-----+-------+
| Libraries            |    62 |    40 |       0 |       2 |   0 |    18 |
| app/controllers      |    89 |    57 |       2 |       1 |   0 |    55 |
| app/helpers          |     9 |     7 |       0 |       1 |   0 |     5 |
| app/models           |    43 |    42 |       2 |       0 |   0 |     0 |
| test/functional      |    52 |    32 |       1 |       9 |   9 |     1 |
| spec/controller      |    59 |    35 |       0 |       9 |   0 |     1 |
| spec/factories       |    36 |    36 |       0 |       0 |   0 |     0 |
+----------------------+-------+-------+---------+---------+-----+-------+
 Code LOC: 146  Test LOC: 103  Code to Test Ratio: 1:0.7
```
=======
wohecha
=======
>>>>>>> eedb552b13b7ef343eac67d447f2c48e7bef17c9
