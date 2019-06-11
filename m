From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: Re: [Jfs-discussion] [PATCH 1/4] vfs: create a generic checking
 function for FS_IOC_SETFLAGS
Date: Tue, 11 Jun 2019 08:41:06 -0500
Message-ID: <fb974a33-2192-30ab-9f31-885c3796360b@oracle.com>
References: <156022833285.3227089.11990489625041926920.stgit@magnolia>
 <156022834076.3227089.14763553158562888103.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20170209; h=Sender:
	Content-Transfer-Encoding:Content-Type:Cc:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:In-Reply-To:MIME-Version:Date:
	Message-ID:From:References:To:Subject:Reply-To:Content-ID:Content-Description
	:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=4cxf0UBt6nj1/ePmJeVYUZ2eUjle3cHmoVwsSy9exEc=; b=FJV0NbqSvks7MN
	QSQwctr5WkA23T5LXXe2olBMsqTABNrpGIdwlyGWUIvr/si4xLJ+JoH2/VZdUwrWyDbq5byrS7NKA
	p6FFPYkC9Jpw9bG0aQa4g5dPPW4RmQ3fWNtmmPzjk1g4EP8VOOjdqTHfnsNj+we+9UirANTvhlBLF
	iJl0VQ0VU05YyYtnqW5AWwx7g/VJeXp8OElm/xc6GwA5atK1iZWN73VFtDL8nH/Z8kgk8smv0Onxn
	bJOANm6G97XObgwDAms+pwbfs29dBwKK5JBw2OeFDuJXsSGoT51vlvy4v1No9yqXUOkyQaLxSKvM5
	PWE1Hs+PZxL8QMY1+BRA==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=NlP/8NoKwtwwPiK6Zh1fsHc3R+zGZgX5fbehxJ41bPs=;
 b=fO36X8sFP3+EfmjD1qFJI4e23MY2tyn5GrMGkga7jQZUJnO4m7H9+qnmLaCnOaQ+tDx0
 mk3M2lRa9Cbj7kpmmQEY4qrPHAbzSOcu/BbnlYiMJ4X2ScIR5NAkP5jkYdVv2eMy2JaE
 KkaOyErzk5GvM1QvdRbE+eSZPIOfRXHWvwf9KTJ+aG/PVXlbkb6ebDLYndonGsER32rZ
 fpc2ufouW5kg849gr1iGvsmibnA0HUne/nwZrbkGeibheDzV4rF8bm5GpZOAIHPGZkuH
 xTczLsghU0CS0fvWWbzlw/loPzasCqJTTH3O+hPZU8mnKlG9HqwnJR6GqkXHrSdTfSJj 0Q== 
In-Reply-To: <156022834076.3227089.14763553158562888103.stgit@magnolia>
Content-Language: en-US
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>, matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, shaggy@kernel.org, ard.biesheuvel@linaro.org, josef@toxicpanda.com, clm@fb.com, adilger.kernel@dilger.ca, jk@ozlabs.org, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, viro@zeniv.linux.org.uk
Cc: cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, linux-efi@vger.kernel.org, reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On 6/10/19 11:45 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a generic checking function for the incoming FS_IOC_SETFLAGS flag
> values so that we can standardize the implementations that follow ext4's
> flag values.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

 -- clip --

> diff --git a/fs/jfs/ioctl.c b/fs/jfs/ioctl.c
> index ba34dae8bd9f..c8446d2cd0c7 100644
> --- a/fs/jfs/ioctl.c
> +++ b/fs/jfs/ioctl.c
> @@ -98,6 +98,12 @@ long jfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		/* Lock against other parallel changes of flags */
>  		inode_lock(inode);
>  
> +		oldflags = jfs_map_ext2(jfs_inode->mode2 & JFS_FL_USER_VISIBLE,
> +					0);
> +		err = vfs_ioc_setflags_check(inode, oldflags, flags);
> +		if (err)
> +			goto setflags_out;

inode_unlock(inode) is not called on the error path.

> +
>  		oldflags = jfs_inode->mode2;
>  
>  		/*

This patch leaves jfs's open-coded version of the same check.

Thanks,
Shaggy

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
