From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Fail to mount NILFS.
Date: Sat, 22 Aug 2009 11:25:33 +0900 (JST)
Message-ID: <20090822.112533.68801227.ryusuke@osrg.net>
References: <200908211918.34720.yuri@itinteg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sat_Aug_22_11_25_33_2009_210)--"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <200908211918.34720.yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org

----Next_Part(Sat_Aug_22_11_25_33_2009_210)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,
On Fri, 21 Aug 2009 19:18:34 +0300, Yuri Chislov wrote:
> Hi,
> 
>  I get error when mount nilfs2 partition.
> 
> mount.nilfs2 /dev/cciss/c0d1p1 /home/
> mount.nilfs2: WARNING! - The NILFS on-disk format may change at any time.
> mount.nilfs2: WARNING! - Do not place critical data on a NILFS filesystem.
> mount.nilfs2: Error while mounting /dev/cciss/c0d1p1 on /home/: Invalid 
> argument
> 
> dmesg output:
> segctord starting. Construction interval = 5 seconds, CP frequency < 30 
> seconds
> NILFS: corrupt root inode.
> 
> Used kernel: 2.6.30.4
> nilfs-utils-2.0.12-3.i386
> 
> 
> Is it possible to fix the partition?
> Is it some tools exists, like fsck?
> 
> Thank you.
> Yuri.

Sorry for the inconvenience.
I'm afraid to say fsck has not been developed yet.

Are there any warnings or error messages of nilfs in syslog before the
problem ?

I'll attach a patch to allow nilfs to mount plain checkpoints.

If you made the kernel from source, try the patch as follows:

 $ cd linux-2.6.30.4
 $ patch -p1 < path-to/0001-nilfs2-remove-snapshot-check-on-mount.patch
 $ make modules
 $ sudo rmmod nilfs2
 $ sudo insmod fs/nilfs2/nilfs2.ko
 $ sudo mount -t nilfs2 -r -o cp=xxx /dev/yyy /mnt

If you succeed to mount a valid past checkpoint, you will be able to
do backup with rsync or so from the checkpoint.

Regards,
Ryusuke Konishi

----Next_Part(Sat_Aug_22_11_25_33_2009_210)--
Content-Type: Application/Octet-Stream
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-nilfs2-remove-snapshot-check-on-mount.patch.bz2"

QlpoOTFBWSZTWU0y904AAU5fgEgwU3///29v3y6//99uUAN+Tru7Op1AOwlEJMFPU/VPU9IPU000
epk0aADQDQ000eoNGg1PUlPZTaaNDQoDZQaNqAaABoAGh6gDQppiKe1T1N6ieptGoaaMnomIBpoa
GQZGgyHGTJoYjE0YBGAmEAYCaaNMjQDCRRNEyaBNkyTFNk0ho0AAGI0AAyQWGRAaaSaxDUBkSEE3
CA3BQgRcXZ+cVWQ7Hsm64EzpaKlLpiugahvrKJUubNpelzyGiCAwtghnKEgn5/zGj8Z7lVVW7evR
mBMA2uLJg+9anLUfyrWZqVUizEVD7MhrnFqc45cys0KlVeLbVXXHF9pTg0x+uQ3NqJOCXiof8wlE
0Ilt0SlDVXQSDAKZj59sIkQTeDo2YnyFBK1Gm4S2oNH4WrLtft0dD+MoboWnoR20FMKgwaJPZUfZ
jqxlq06Ym3BdiuSkuRojgKHvTnEFD0BjHCAXKFDS1PR5beC0Yxt6CWgxmM5UaIjGPSIijUV/Y8Xd
lMNN2oxH9AkUJjnMRmJ6YiaZswuVuAgZQNWDVPvuZCUyUTToaN7GuUKphSI0tjrwLVpLeGipccWK
cSmSGYMiJYmzQJBhfWwTsgl/uJ9mZzBQbLdYLMBFxR6nPCBsK2xWBwiXUsJpH1X8um34Yzs1CuOe
wOyOze/LMGX5sNlFjd0zRjX1xZvi+TAHGQYLxXBeRSHSMYE1KyZHQ0xhWEWjDbzoKCgYmNazj7Bg
1P4WeRwoYejuhJUmY0z+HMY0SCh5uNedU6dROHXZjxUfED+GJZELcyfXJtiHSWvGQkiYqYS4qiSD
Zht0kZ1/H/USMSwVjbOrPAwFvResmTYcxOrR7zc31uIkt6wNN1Ezywq4plp0b5AXr6JdUyTwaRCk
zZTYTfPg7OnVlJzTkQR4lh2hFpuAI23Gxz8hUW3k9y3AXpGsimM7ZmMeBXFGq5BhIkMqEM2liqY0
as+sdAazLsM6neWrfeEOskKVh0mbHRpEtjQi1nWZVIkqSw32ZYk88DsL0sJoJjFZxCKYNJzBVYBg
55iEw0VjReYIYy9NFI8ye3uHGLWUHkqwHQXFZw78TFct9L4MwcppKbUEyCsW2SV2fkqGMDtYqFo9
pIuXCcEbDchLxu6BDmOI6sdxrVNIZEoSCSMNrpV4TG5E5RdQnUPj4ZAyJCuECuwlXNTgoIoYYBJO
tSyhCygErDpaXcsBdD41EB7AJCbw4UeY2hwW0/xdyRThQkE0y904

----Next_Part(Sat_Aug_22_11_25_33_2009_210)--
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

----Next_Part(Sat_Aug_22_11_25_33_2009_210)----
