From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs_cleanerd on root partition
Date: Sun, 21 Jun 2009 18:39:37 +0900 (JST)
Message-ID: <20090621.183937.71761103.ryusuke@osrg.net>
References: <20090620211939.GA5937@odysseus.gateway.2wire.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090620211939.GA5937-SsamVeerapxB2jdCq39ADS3k8SM3+oTIrE5yTffgRl4@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, psykojime-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org

Hi,
On Sat, 20 Jun 2009 16:19:39 -0500, James Erickson wrote:
> i am new to nilfs2 so i am sorry to ask such a simple question. how
> do i get nilfs_cleanerd to run on my root partition? my disk is a 64
> GB intel ssd and it is completely full of checkpoints. my system is
> originally 4 GB in size. it is gentoo amd64 running
> linux-2.6.30-gentoo-r1. it has nilfs2 support compiled in the
> kernel, not as a module. i thought that nilfs_cleanerd would run
> when the root patition is mounted but i guess i was wrong. i will
> gladly post any requested data. thank you for any help you can offer
> in this matter.

nilfs_cleanerd is invoked when the partition is mounted, but sleeps if
no reclaimable data exists.

Is there nilfs_cleanerd process ?

 $ ps aux | grep nilfs_cleanerd

If it exists, please try decreasing the protection period in
/etc/nilfs_cleanerd.conf.  Nilfs tries to preserve all past data
within the period.

 $ sudo vi /etc/nilfs_cleanred.conf

  # Protection period in second
- protection_period   3600
+ protection_period   300

After changed the conf file, you must send a HUP signal to the cleaner
daemon in order to reflect the change.

 $ mount -t nilfs2
 /dev/sdb1 on / type nilfs2 (rw,gcpid=14126)
 $ sudo kill -HUP 14126

Then, it will start working to make free space.


If the cleanerd did not exist, you can invoke it by hand.

 # nilfs_cleanerd /dev/sdb1 /

In this case, you also have to shutdown it by hand.

Cheers,
Ryusuke Konishi
