# 模块化TableView



## 什么是模块化TableView?



### 举个例子

**现在有需求让你修改一个类似于微博个人中心的界面,这种界面几乎所有内容都是写死的界面,虽然我估计微博的个人中心是完全动态的,但这里先假设是写死的,况且模块化也适用于动态界面**



#### 最常见的写法

**普通的tableView,对应不同的cell:**

![](http://wx3.sinaimg.cn/large/70a5dc58gy1fuaf3wrvphj20bb0k5q3m.jpg)



**建立个普通数组,把不同内容对应的模型丢进去,如model内容:**

```
struct TableModel_1 {

  var icon:UIImage?

  var title:String = ""

  var desc:String = ""

}

struct TableModel_2 {

  var min:Double = 0
  var max:Double = 0
  var current:Double = 0

}
struct TableModel_3 {

  var desc:String = ""

}

struct TableModel_4 {

  var icon:UIImage?

  var title:String = ""

  var backgroundImage:UIImage?

}
```

**然后到cellForRow方法中获取不同的model,分开获取cell,设置cell:**

```
if let cell = cell as? RegularCell{
  cell.titleLabel.text = node.title
  cell.descriptionLabel.text = node.desc
  cell.iconImageView.image = node.icon
}
if let cell = cell as? RangeCell{
  cell.titleLabel.text = node.title
  cell.maxLabel.text = "\(node.max)"
  cell.minLabel.text = "\(node.min)"
  cell.sliderView.value = Float(node.current)
}
if let cell = cell as? DescriptionCell{
  cell.descriptionLabel.text = node.desc
}
if let cell = cell as? BlurCell{
  cell.titleLabel.text = node.title
  cell.iconImageView.image = node.icon
  cell.backgroundImageVIew.image = node.backgroundImage
}
```

**再到didSelectRow中根据indexPath对不同的cell点击事件做不同的处理**

```
let pushedCtr = PushedCtr()

switch indexPath.section {
case 0:
  switch indexPath.row {
  case 0: pushedCtr.title = "2018新闻"
  case 1: pushedCtr.title = "今日温度"
  default: break
}
case 1:
  switch indexPath.row {
  case 0: pushedCtr.title = "广告位招租"
  case 1: pushedCtr.title = "今日湿度"
  case 2: pushedCtr.title = "谷歌回归"
  default: break
}
default:break
}

self.navigationController?.pushViewController(pushedCtr, animated: true)
```

**有的人可能会建多个数组,然后分开存放标题和图片的内容,这一步优化这里就跳过直接写成model**



**成品:**

![](http://wx2.sinaimg.cn/large/70a5dc58gy1fuag7b7qtjj20hs0vkju6.jpg)



#### 仔细一看,这里可以做的优化不是一般的多

**首先cellForRow中,设置cell的工作可以交给各自的cell处理,在获取cell后只要对cell设置model就行了**

**但这样子的话cell和model的耦合就太高了,一般会再建一层viewModel来实现cell的设置, 由于不是重点这里就先不做**

**接着model其实不用分那么多种,所有类型的数据都可以放在一起,不同的类型分开放在一起,后期需要改动也相对方便一些**

```
struct TableNode {
  var type:Int

  //type == 0
  var icon:UIImage?
  var title:String = ""
  var desc:String = ""

  //type == 1
  var min:Double = 0
  var max:Double = 0
  var current:Double = 0
  //title

  //type == 2
  //desc


  //type == 3
  //title
  //icon
  var backgroundImage:UIImage?
}
```

> 偏题一下,由于ObjC类的底层实现,编译后的二进制包会保存所有类各自的信息,不像C++具有zero-cost abstraction ,编译后的类信息只有偏移量.所以创建的ObjC类越多,二进制包就会越大,虽然增加的大小一般可以忽略不计,但前期稍微注意一下可以推迟后期可能会遇到下载包达到150M的问题

**既然把model合并了,可以通过访问者模式为不同类型的Cell编写不同的初始化方法区分类型,后期需要添加新的Cell值需要一行代码就知道设置什么参数,为了区分,修改后成为node**

```
struct TableNode {
  var type:Int

  var icon:UIImage?
  var title:String = ""
  var desc:String = ""
  init(regularWithIcon icon:UIImage?, title:String , description:String) {
    self.type = 0
    ...
  }
  var min:Double = 0
  var max:Double = 0
  var current:Double = 0
  init(rangeWithTitle title:String , min:Double , max:Double,current:Double) {
    self.type = 1
    ...
  }

  init(description:String) {
    self.type = 2
    self.desc = description
  }

  var backgroundImage:UIImage?
    init(webWithTitle title:String , backgroundImage:UIImage , icon:UIImage) {
    self.type = 3
    ...
  }
}
```

**规范化可以通过适配器模式给Cell创建协议,协议中只有一行属性model**

```
protocol TableNodeProtocol {

  var node:TableNode?{get set}

}

let node = nodeList[indexPath.section][indexPath.row]
var cell = tableView.dequeueReusableCell(withIdentifier: "\(node.type)") as? (UITableViewCell & TableNodeProtocol)
cell?.node = node

```

**可以把cell的点击事件也可以通过策略模式放到node中,到时候didSelectRow就能把操作和indexPath的绑定转型成操作和model绑定,后期怎么改都不需要在意这里**

```
struct TableNode {

  var type:Int

  var icon:UIImage?

  var title:String = ""

  var desc:String = ""

  var selectCell:(()->())?

  init(regularWithIcon icon:UIImage?, title:String , description:String,selectCell:@escaping ()->()) {

    self.type = 0

    ...

    self.selectCell = selectCell

  }

  var min:Double = 0

  var max:Double = 0

  var current:Double = 0

  init(rangeWithTitle title:String , min:Double , max:Double,current:Double,selectCell:@escaping ()->()) {

    self.type = 1

    ...

    self.selectCell = selectCell

  }

  init(description:String,selectCell:@escaping ()->()) {

    self.type = 2

    self.desc = description

    self.selectCell = selectCell

  }

  var backgroundImage:UIImage?

  init(webWithTitle title:String , backgroundImage:UIImage , icon:UIImage,selectCell:@escaping ()->()) {

    self.type = 3

    ...

    self.selectCell = selectCell

  }
}

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  table.deselectRow(at: indexPath, animated: true)
  nodeList[indexPath.section][indexPath.row].selectCell?()
}
```

**做完上面几步,你会发现今天的主题已经实现了,现在已经把tableView内容模块化了,不管是改动顺序也好,改动cell内容也好,改动点击cell的操作也好,都能在一个地方处理,不需要根据indexPath调整内容(或者创建一堆的枚举用于区分),既符合接口隔离原则,也符合迪米特法则,添加内容时只需:**

```
subList.append(TableNode(regularWithIcon: #imageLiteral(resourceName: "news"), title: "2018新闻", description: "点击查看更多"){ [weak self] in
  let pushedCtr = PushedCtr()
  pushedCtr.title = "2018新闻"
  self?.navigationController?.pushViewController(pushedCtr, animated: true)
})
```

**除了添加新的Cell类型,后续匹配工作都可以忽略不管**

