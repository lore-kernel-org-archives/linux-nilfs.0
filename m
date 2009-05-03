From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: nilfs_cpfile_delete_checkpoints: cannot delete
 block
Date: Sun, 03 May 2009 11:26:49 +0200
Message-ID: <49FD6359.1020405@prnet.org>
References: <49FCCF6F.3040101@prnet.org>
	<20090503.170847.69363313.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090503.170847.69363313.ryusuke-sG5X7nlA6pw@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi,

I have tried your patch.

The more verbose error message is:

nilfs_cpfile_delete_checkpoints: cannot delete block: cno=1407, range = 
[11, 75990)
NILFS: GC failed during preparation: cannot delete checkpoints: err=-2

Bye,
David Arendt

Ryusuke Konishi wrote:
> Hi David,
> On Sun, 03 May 2009 00:55:43 +0200, David Arendt wrote:
>   
>> Hi,
>>
>> Until now nilfs-2.0.12 has run very stable without data corruption.
>> However on one partition (600G) I have got the following errors while 
>> running the cleaner:
>>
>> nilfs_cpfile_delete_checkpoints: cannot delete block
>> NILFS: GC failed during preparation: cannot delete checkpoints: err=-2
>>
>> This is a partition mainly holding large temporary render files (can be 
>> up to 25gb/file). There are currently 132702 snapshots.
>>
>> As this partition is not used during the next few days, I will leave it 
>> with the error so if you would like me to test further things, please 
>> let me know.
>>
>> Bye,
>> David Arendt
>>     
>
> I have reviewed the function in question, but could not find any
> likely problems.
>
> Could you try the following patch?
>
> It's applicable to v2.0.12.
>
> I have some pending patches later than 2.0.12, but they seem to be
> independent with your problem.
>
> Thanks,
> Ryusuke Konishi
> --
> diff --git a/fs/cpfile.c b/fs/cpfile.c
> index 038d660..9a6a6ae 100644
> --- a/fs/cpfile.c
> +++ b/fs/cpfile.c
> @@ -342,8 +342,12 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
>  					cpfile, cno);
>  				if (ret == 0)
>  					continue;
> -				printk(KERN_ERR "%s: cannot delete block\n",
> -				       __func__);
> +				printk(KERN_ERR "%s: cannot delete block: "
> +				       "cno=%llu, range = [%llu, %llu)\n",
> +				       __func__,
> +				       (unsigned long long)cno,
> +				       (unsigned long long)start,
> +				       (unsigned long long)end);
>  				goto out_sem;
>  			}
>  		}
> diff --git a/fs/dat.c b/fs/dat.c
> index 523eee7..7463301 100644
> --- a/fs/dat.c
> +++ b/fs/dat.c
> @@ -381,11 +381,9 @@ int nilfs_dat_translate(struct inode *dat, __u64 vblocknr, sector_t *blocknrp)
>  	entry = nilfs_palloc_block_get_entry(dat, vblocknr, entry_bh, kaddr);
>  	blocknr = le64_to_cpu(entry->de_blocknr);
>  	if (blocknr == 0) {
> -#ifdef CONFIG_NILFS_DEBUG
>  		printk(KERN_DEBUG "%s: invalid virtual block number: %llu\n",
>  		       __func__, (unsigned long long)vblocknr);
> -		BUG();
> -#endif
> +		WARN_ON(1);
>  		ret = -ENOENT;
>  		goto out;
>  	}
>   
