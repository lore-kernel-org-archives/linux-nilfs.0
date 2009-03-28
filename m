From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: error on kernel 2.6.29 while running cleaner on a
 1tb volume
Date: Sat, 28 Mar 2009 09:09:27 +0100
Message-ID: <49CDDB37.9030603@prnet.org>
References: <49CC6193.9040900@prnet.org>	<49CC6A6C.9060006@prnet.org>	<20090327.152005.04656990.ryusuke@osrg.net>
	<20090327.194735.32664212.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090327.194735.32664212.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

today I have tried the lssu on a dedicated server running nilfs and here 
I had the following result:

fr ~ # lssu -a /dev/sda2 | grep -e "2009-" | grep -v -e "-d-"
                2558  2009-03-23 16:59:05  ---        2048
                4967  2009-03-28 09:07:10  ad-        1928

so I suppose corruption will soon occur here.

Is there something I can do to manually mark it as dirty or should I go 
the backup/restore route ?

Thanks in advance

Bye,
David Arendt


Ryusuke Konishi wrote:
> Hi David,
> On Fri, 27 Mar 2009 15:20:05 +0900 (JST), Ryusuke Konishi wrote:
>   
>> Hi,
>> On Fri, 27 Mar 2009 06:55:56 +0100, David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org> wrote:
>>     
>>> Hi,
>>>
>>> one thing I forgot to mention, in /etc/nilfs_cleanerd.conf I changed 
>>> n_segments_per clean to 20 in order to clean faster when running the 
>>> cleaner manually. Could this have any influence ?
>>>       
>> Yes, maybe.  It raises memory pressure then may induce unusual path of
>> execution like cache invalidation.  It may even increase the chance of
>> revealing underlying problems in relocation of on-disk blocks.
>>
>> Decreasing cleaning_interval is safer in general.  We'll try the
>> condition.
>>
>> Regards,
>> Ryusuke
>>     
>
> I examined the case of nsegments_per_clean = 20 and met an
> inconsistent state as follows:
>
>  # lssu -a
>              SEGNUM        DATE     TIME STAT     NBLOCKS
>                ...
>                7418  2009-03-27 18:41:33  -d-        2048
>                7419  2009-03-27 18:41:48  -d-        2048
>                7420  2009-03-27 18:42:08  -d-        2048
>                7421  2009-03-27 18:42:28  -d-        2048
>                7422  2009-03-27 18:42:48  ---        2048
>                7423  2009-03-27 18:43:03  ---        2048
>                7424  2009-03-27 18:43:23  -d-        2048
>                7425  2009-03-27 18:43:33  ad-        1166
>                7426  ---------- --:--:--  ad-           0
>                7427  ---------- --:--:--  ---           0
>                ...
>
> Here, the segment 7422 and 7423 are in-use but not dirty.
>
> This is crucial because these segments will be reallocated and
> overridden later.  I suspect there is a bug of error handling
> somewhere, and it evaporates the dirty flag and causes the crash.
>
> If you have a (not broken) nilfs partition made under heavy stress,
> could you try ``lssu -a'' likewise ?
>
> I'll dig into this from now.
>
> Regards,
> Ryusuke Konishi
>   
