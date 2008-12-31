From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Kernel Bug after corrupted filesystem
Date: Wed, 31 Dec 2008 23:36:20 +0900 (JST)
Message-ID: <20081231.233620.76970897.ryusuke@osrg.net>
References: <20081230131953.298540@gmx.net>
	<20081231.115354.105606600.ryusuke@osrg.net>
	<20081231111707.25420@gmx.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081231111707.25420-hi6Y0CQ0nG0@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, robinx99-hi6Y0CQ0nG0@public.gmane.org

Hi,
On Wed, 31 Dec 2008 12:17:07 +0100, "Dennis Peiler" wrote:
> > Again, it seems that a btree corruption happened.
> > Sorry, but it's hard to track the cause directly from the stack dump.
> > 
> Is there anything else I could provide? That might help to track
> down problems

Thanks.
Well, could you try to get some information with a debug build module?

First, pull the latest code from our git repository.

The debug build module can be built by commenting out the following
line of the fs/Makefile.

   #CONFIG_NILFS_DEBUG=y

Then, set debug levels before mounting as follows:

  # modprobe nilfs2
  # echo "-vvv fs -vvv recovery -vvv mdt -vvv btnode -vv dat" > /proc/fs/nilfs2/debug_option
  # mount -t nilfs2 /dev/xxx /test

This will log some more information in syslog including
block addresses.
What I'd like to see next is content of key disk blocks, but first
we need to know rough situation.

Regards,
Ryusuke
