From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: error on kernel 2.6.29 while running cleaner on a
 1tb volume
Date: Sun, 29 Mar 2009 17:25:32 +0200
Message-ID: <49CF92EC.2020803@prnet.org>
References: <20090327.152005.04656990.ryusuke@osrg.net>	<20090327.194735.32664212.ryusuke@osrg.net>	<49CDDB37.9030603@prnet.org>
	<20090328.215257.15833655.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090328.215257.15833655.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,

Many thanks for the patch.
I have seen that you already have included the latest patch in git so I 
used the git version. I have done a backup/restore on my nilfs2 
partitions in order to be sure to start with a clean state. So far no 
corruption did occur and and all used segments have been marked dirty. 
As generally the corruption only occurred after several times of 
cleaning, I can only say in a few days, if the patch really solved the 
problem.

I have however had the following result on a fresh restored 1tb 
partition where the cleaner has not been  run yet:

server ~ # lssu -a /dev/sda10 | grep -e "2009-" | grep -v -e "-d-"
               14335  2009-03-29 01:44:28  ad-        2048
               14589  2009-03-29 01:46:23  ad-         941

For all other partitions I have only one segment marked as active. Can 
it be a normal case for nilfs2 that 2 segments are marked as active or 
is there something weird going on here ? dmesg returns nothing special 
about this volume. There has also been no system crash so this volume 
should have been mounted/unmounted correctly.

Bye,
David Arendt

Ryusuke Konishi wrote:
> Hi,
> On Sat, 28 Mar 2009 09:09:27 +0100, David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org> wrote:
>   
>> Hi,
>>
>> today I have tried the lssu on a dedicated server running nilfs and here 
>> I had the following result:
>>
>> fr ~ # lssu -a /dev/sda2 | grep -e "2009-" | grep -v -e "-d-"
>>                 2558  2009-03-23 16:59:05  ---        2048
>>                 4967  2009-03-28 09:07:10  ad-        1928
>>
>> so I suppose corruption will soon occur here.
>>     
>
> Oh, it would come.
>
>   
>> Is there something I can do to manually mark it as dirty or should I go 
>> the backup/restore route ?
>>     
>
> No, sorry.  You may as well go the backup/restore route.
>
> BTW, I found a bug in sufile that may relate to this problem.  The
> following patch fixes the bug. (I'm now testing this)
>
> If I can confirm that the patch has effect on the dirty flag
> evaporation, I will release an update ASAP.
>
> Othewise, I'll continue debugging.
> Please try the patch in the meantime.
>
> Regards,
> Ryusuke Konishi
>
> diff --git a/fs/sufile.c b/fs/sufile.c
> index e64a5de..0ea8558 100644
> --- a/fs/sufile.c
> +++ b/fs/sufile.c
> @@ -553,7 +553,6 @@ int nilfs_sufile_set_error(struct inode *sufile, __u64 segnum)
>  
>  	nilfs_segment_usage_set_error(su);
>  	kunmap_atomic(kaddr, KM_USER0);
> -	brelse(su_bh);
>  
>  	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
>  	header = nilfs_sufile_block_get_header(sufile, header_bh, kaddr);
>   
