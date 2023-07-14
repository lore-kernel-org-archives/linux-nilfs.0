From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: {WHAT?} read checksum verification
Date: Fri, 14 Jul 2023 21:22:35 +0200
Message-ID: <eb47952c-93eb-a776-7cfb-c50219513e78@prnet.org>
References: <174f995c-e794-74c4-24d6-52451f3f3f28@prnet.org>
 <25775.10549.41499.886957@petal.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <25775.10549.41499.886957-Lv72GqZ7opur1GY8YIlKTvXRex20P6io@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: list Linux fs NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

Quoting was not possible as I deleted the original mail to fast, sorry 
for this. This reply is concering Ryusuke Konishis mail.

First of all, you are 100% right, the underlying block layer should 
never return corrupted data, but bad things are unfortunately happing. 
In this case a bug in the iscsi server itself was the culprit and is now 
fixed.

I did several tests by untaring the content a an elastalert container in 
order to compare real world performance if someone is interested:

nilfs2 directly on iscsi: tar -xpf /tmp/elastalert.tar  0.91s user 5.19s 
system 6% cpu 1:25.71 total

nilfs2 with underlying dm-integrity in journal mode: tar -xpf 
/tmp/elastalert.tar  1.04s user 5.23s system 3% cpu 3:18.90 total

nilfs2 with underlying dm-integrity in bitmap mode: tar -xpf 
/tmp/elastalert.tar  1.00s user 5.17s system 4% cpu 2:15.04 total

nilfs2 with underlying dm-integrity in direct mode: tar -xpf 
/tmp/elastalert.tar  1.10s user 5.33s system 7% cpu 1:26.27 total

read performance in all for tests after an unmount/remount: tar -cf 
/dev/null .  1.11s user 1.80s system 5% cpu 51.300 total

Another test was writing 1024 bytes random garbage on the dm-integrity 
underlying device and doing again a tar -cf /dev/null .

Result:

[ 6005.098464] device-mapper: integrity: dm-0: Checksum failed at sector 
0x2200f
[ 6005.098484] NILFS error (device dm-0): nilfs_readdir: bad page in #4031
[ 6005.170770] Remounting filesystem read-only

So dm-integrity seems effectively a good choice.

I don't now Ryusuke if you still remember me, I was the contributor of 
the "allow cleanerd to suspend GC based on the number of free segments 
patches" long time ago :-)

Bye,

David Arendt

