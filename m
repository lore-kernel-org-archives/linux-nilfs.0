From: "Paul L" <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: (no subject)
Date: Tue, 9 Dec 2008 11:16:33 -0500
Message-ID: <856033f20812090816l183c974dj9eed760b3deedb8c@mail.gmail.com>
References: <856033f20812081303v12353110jf51704b81d2a760@mail.gmail.com>
	<20081209.202059.122418779.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081209.202059.122418779.ryusuke-sG5X7nlA6pw@public.gmane.org>
Content-Disposition: inline
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

On 12/9/08, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> You can manually start nilfs_cleanerd, or you can do it through mount
> program.
>
> For example, if your boot partition is initially mounted read-only,
> you can change it to writable mount by a re-mount option:
>
>  # mount -t nilfs2 -o rw,remount /dev/xxx /mount-dir
>
> This remount operation involves invocation of nilfs_cleanerd.

Strangely, the init scripts already did a remount of the root
partition (with remount option), but cleanerd is not invoked. I had to
do it for a second time in rc.local, then it becomes ok.

>> BTW, thanks for the exellent work, the performance is great on my SSD
>> netbook, much better than ext2 and reiserfs.
>
> Interesting.
>
> Could you tell me what brand of SSD is used in the netbook?

It's Intel SSD (SSDPAM0008G1EA), a very slow SSD with only 5-6 MB/s
write speed. My netbook is Acer Aspire One model AOA110.

-- 
Regards,
Paul Liu

Yale Haskell Group
http://www.haskell.org/yale
