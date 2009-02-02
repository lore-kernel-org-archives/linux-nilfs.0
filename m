From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: silent random symbolic link corruption
Date: Mon, 02 Feb 2009 22:01:10 +0100
Message-ID: <49875F16.7060107@prnet.org>
References: <4984B0DC.6080905@prnet.org>	<4984DCF3.8030302@prnet.org>	<20090202.114209.59790430.ryusuke@osrg.net>
	<49872E1E.4090209@prnet.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <49872E1E.4090209-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
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

Well in fact I cannot find where the  problem is coming from. I am also
not sure if tar or nilfs2 is causing it. Actually I am using tar -xPpf
as this will create symlinks directly without passing through the
sometimes failing delaying mechanism. Please tell me if you want any
further information.

Bye,
David Arendt

David Arendt wrote:
> Hi,
>
> I am still inverstigating here, I created tar files with 100000 symbolic
> links, and they extracted without any problem. Only a tar of my whole
> nfsroot directory fails to extract properly to nilfs2, but does
> correctly to ext4.I wouldn't mind giving you that files, but it are
> 3.3gbytes. What is also curious is that the stat calls in tar seem to
> return the right inode number, but at the check, it is 0. I am currently
> adding debugging printfs to tar in hope to catch the problem this way.
>
> Bye,
> David Arendt
>
> Ryusuke Konishi wrote:
>   
>> Hi David,
>> On Sun, 01 Feb 2009 00:21:23 +0100, David Arendt wrote:
>>   
>>     
>>> Hi,
>>>
>>> I narrowed the problem down. I'm not sure if it's a problem of tar or of
>>> nifls2.
>>>
>>> Tar handles symbolic links this way:
>>>
>>> during extraction: if symbolic link and absolute path create a 0 byte
>>> file and record link and stat information
>>>
>>> after extraction: for every symbolic link verify that actual
>>> st_dev,st_ino and st_mtime are the same as on creation of the 0 byte
>>> file, and only then create the link
>>>
>>> for some 0 byte files st_ino is different between the first and the
>>> second stat of the 0 byte file. As I don't know the nilfs2 internal
>>> behavior, so could  you please tell me if this is the normal behavior of
>>> nilfs2 or if there is something strange with this ? If it's the normal
>>> behavior, maybe I should file a bug for tar ?
>>>     
>>>       
>> This behavior seems unusual.
>> Could you send me a small tar file which can reproduce the problem ?
>>  
>>   
>>     
>>> This patch for tar 1.21 solves the symlink problem but I don't know if
>>> the problem is to be solved on the tar end or on the nilfs2 end.
>>>
>>>
>>> diff -Naur tar-1.21/src/extract.c tar-1.21.new/src/extract.c
>>> --- tar-1.21/src/extract.c	2008-10-30 15:10:28.000000000 +0100
>>> +++ tar-1.21.new/src/extract.c	2009-01-31 23:32:03.000000000 +0100
>>> @@ -1267,7 +1267,6 @@
>>>  	     removed by a later extraction.  */
>>>  	  if (lstat (source, &st) == 0
>>>  	      && st.st_dev == ds->dev
>>> -	      && st.st_ino == ds->ino
>>>  	      && timespec_cmp (get_stat_mtime (&st), ds->mtime) == 0)
>>>  	    {
>>>  	      /* Unlink the placeholder, then create a hard link if possible,
>>>
>>>
>>> What do you think ?
>>>     
>>>       
>> I think this comparision is appropriate to confirm identity of the
>> placeholder file.
>>
>> I have no idea why inode number had changed as you reported.
>> Symbolic links of nilfs2 are simply implemented.
>>
>> If it's unique to nilfs2, you may hit some sort of timing issue.
>> I think a sample tar file would be helpful to figure out what's
>> happening.
>>
>> Regards,
>> Ryusuke Konishi
>>
>>   
>>     
>>> David Arendt wrote:
>>>     
>>>       
>>>> Hi,
>>>>
>>>> After using nilfs2 for half a year now on data partitions without any
>>>> problems, I wanted to try it for the root partition. This way I
>>>> discovered a silent random symbolic link corruption problem.
>>>>
>>>> Versions:
>>>>
>>>> latest nilfs2 git module
>>>> kernel 2.6.28.2
>>>> tar 1.20
>>>>
>>>> Step to reproduce it:
>>>>
>>>> tar -xpf zz1.tar (where zz1.tar is a tar file containing many symbolic
>>>> links (in my case a directory containing 2 root filesystems for remote
>>>> booting)
>>>>
>>>> On  untar some symbolic links are missing and 0 byte files are existing
>>>> instead.
>>>>
>>>> I repeated the test 3 times on a freshly formated nilfs2 partition and
>>>> always had other links missing.
>>>>
>>>> I am currently trying to bzip2 the big tar file and untar this one in
>>>> order to verify if there are no timing issues and will report back when
>>>> this test is finished.
>>>>
>>>> Could you please look into this ?
>>>>
>>>> Thanks in advance
>>>> Bye,
>>>> David Arendt
>>>>
>>>> _______________________________________________
>>>> users mailing list
>>>> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
>>>> https://www.nilfs.org/mailman/listinfo/users
>>>>   
>>>>       
>>>>         
>>> _______________________________________________
>>> users mailing list
>>> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
>>> https://www.nilfs.org/mailman/listinfo/users
>>>     
>>>       
>> _______________________________________________
>> users mailing list
>> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
>> https://www.nilfs.org/mailman/listinfo/users
>>   
>>     
>
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
>   
