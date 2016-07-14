//
//  InfonationTableViewCell.m
//  wenyao-store
//
//  Created by chenpeng on 15/1/21.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "InfonationTableViewCell.h"
#import "OrderModel.h"
@implementation InfonationTableViewCell

- (void)awakeFromNib {
    
    // Initialization code
}
-(void)setCells:(id)data andindex:(int)index clickType:(int)type{
    [self setCell:data];
    
    
    OrderclassBranch *infodic=data;
    CGSize sized=[self calculateHeightcell:infodic.desc];
    if (type==1) {
        
        if (index==0) {
            [self calculateFrame:infodic.title];
        }
        if (index==1) {
            int types=[infodic.type intValue];
            if (types==1) {
                self.productDetail.text=@"折扣";
            }
            if (types==2) {
                self.productDetail.text=@"抵现";
            }
            if (types==3) {
                self.productDetail.text=@"买赠";
            }
        }
        if (index==2) {
            
            UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(0, sized.height+18, APP_W, 8)];
            lable.backgroundColor=RGBHex(qwColor11);//
            lable.tag=100;
            [self.contentView addSubview:lable];
            [self calculateFrame:infodic.desc];
            
        }
        if (index==3) {
            [self calculateFrame:infodic.proName];
        }
        if (index==4) {
            [self calculateFrame:infodic.nick];
            
        }
        if (index==5) {
            [self calculateFrame:infodic.inviter];
            if(infodic.inviterName && ![infodic.inviterName isEqualToString:@""]){
                
                UILabel  *lable=[[UILabel alloc]initWithFrame:CGRectMake(180, 8, 200, 17)];
                lable.font=[UIFont systemFontOfSize:13.0f];
                lable.textColor=RGBHex(qwColor3);
                lable.tag=1000;
                lable.text=[NSString stringWithFormat:@"(%@)",infodic.inviterName];
                [self.contentView addSubview:lable];
            }
        }
        if (index==6) {
            int types=[infodic.type intValue];
            UILabel  *lable=[[UILabel alloc]initWithFrame:CGRectMake(180, 8, 200, 17)];
            float a=[infodic.discount floatValue];
            lable.font=[UIFont systemFontOfSize:13.0f];
            lable.textColor=RGBHex(qwColor3);
            lable.tag=1000;
            [self.contentView addSubview:lable];
            int totalLargess = 0;
            if (infodic.totalLargess) {
                totalLargess=[infodic.totalLargess intValue];
            }
            if (types!=3) {
                lable.text=[NSString stringWithFormat:@"本订单共优惠%.2f元",a];
            }else{
                lable.text=[NSString stringWithFormat:@"本订单赠送%d件赠品",totalLargess];
            }
            //保证不会空值
            double norprice=[infodic.price doubleValue];
            NSString *Str=[NSString stringWithFormat:@"￥%.2lf",norprice];
            [self calculateFrame:Str];
        }
        if (index==7) {
            NSString *str=[NSString stringWithFormat:@"%@",infodic.quantity];
            [self calculateFrame:str];
        }
        if (index==8) {
            [self calculateFrame:infodic.date];
        }
    }else{
        if (index==0) {
            [self calculateFrame:infodic.title];
        }
        if (index==1) {
            int types=[infodic.type intValue];
            if (types==1) {
                self.productDetail.text=@"折扣";
            }
            if (types==2) {
                self.productDetail.text=@"抵现";
            }
            if (types==3) {
                self.productDetail.text=@"买赠";
            }
            
        }
        if (index==2) {
            UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(0, sized.height+18, APP_W, 8)];
            lable.backgroundColor=RGBHex(qwColor11);
            lable.tag=100;
            [self.contentView addSubview:lable];
            
            [self calculateFrame:infodic.desc];
        }
        if (index==3) {
            [self calculateFrame:infodic.proName];
        }
        if (index==4) {
            [self calculateFrame:infodic.nick];
        }
        if (index==5) {
            int type=[infodic.type intValue];
            UILabel  *lable=[[UILabel alloc]initWithFrame:CGRectMake(180, 8, 200, 17)];
            lable.font=[UIFont systemFontOfSize:13.0f];
            lable.textColor=RGBHex(qwColor3);
            lable.tag=500;
            float aconnt=[infodic.discount floatValue];
            int totalLargess=0;
            if (infodic.totalLargess) {
                totalLargess=[infodic.totalLargess intValue];
            }
            if (type==3) {
                lable.text=[NSString stringWithFormat:@"本订单送%d件赠品",totalLargess];
            }else{
                
                lable.text=[NSString stringWithFormat:@"本订单共优惠%.2f元",aconnt];
            }

            
            [self.contentView addSubview:lable];
            
            //保证不会空值
            double norprice=[infodic.price doubleValue];
            NSString *Str=[NSString stringWithFormat:@"￥%.2lf",norprice];
            [self calculateFrame:Str];
        }
        if (index==6) {
            NSString *str=[NSString stringWithFormat:@"%@",infodic.quantity];
            [self calculateFrame:str];
        }
        if (index==7) {
            [self calculateFrame:infodic.date];
        }
    }
    
    
    
}
-(void)calculateFrame:(NSString *)str{
    CGSize sz=[str boundingRectWithSize:CGSizeMake(200, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil].size;
    self.productDetail.text=str;
//    CGSize sz=[GLOBALMANAGER sizeText:str font:[UIFont systemFontOfSize:14.0f] limitWidth:224];
//    sz.height+=1;
//    sz.width+=10;
    CGRect frm=self.productDetail.frame;
    frm.size=sz;
    self.productDetail.frame=frm;
    NSLog(@"%@ ",NSStringFromCGSize(sz));
//    self.productDetail.frame=CGRectMake(self.productDetail.frame.origin.x, self.productDetail.frame.origin.y, sizes.width, sizes.height);
}

-(CGSize)calculateHeightcell:(NSString *)str{
    CGSize sizes=[str boundingRectWithSize:CGSizeMake(200, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil].size;
    return sizes;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)UIGlobal{
    [super UIGlobal];
    self.separatorLine.backgroundColor = [UIColor clearColor];
    
//    self.contentView.backgroundColor=[UIColor yellowColor];
//    self.productDetail.backgroundColor=[UIColor greenColor];
}
-(void)setCell:(id)data{
    [super setCell:data];
    
}
@end
