From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs2 fails to mount after io/error
Date: Tue, 02 Dec 2008 14:22:25 +0900 (JST)
Message-ID: <20081202.142225.78011419.ryusuke@osrg.net>
References: <20081128153732.be4f5cf8.adrian@blinkenlights.ch>
	<20081202.015029.88482681.ryusuke@osrg.net>
	<20081201171411.99215829D@blinkenlights.ch>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081201171411.99215829D-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org>
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
To: adrian-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On Mon, 1 Dec 2008 18:14:35 +0100, Adrian Ulrich wrote:
> Hi,
> 
> > 
> > For nilfs2, if a superblock was written ahead of the segment pointed
> > by the superblock, this can happen.
> > 
> > Anyhow, I'll review the source code some more.
> 
> Ok. Let me know if you need something from me.
> (metadata dump, etc..)

Thanks, 

Could you get debug log with a DEBUG option?

By commenting out the following line in nilfs2/fs/Makefile,
you can make the nilfs2 module for debugging purpose.

 # CONFIG_NILFS_DEBUG=y

Compilation and installation are as usual.

Then write the following option to a procfs file 'nilfs2/debug_option'
before mounting the partition.

 # modprobe nilfs2
 # echo "-vvv recovery" > /proc/fs/nilfs2/debug_option
 # mount -t nilfs2 -r /dev/xxx /test
 ...

This will log trace messages of recovery function.


Thanks in advance,
Ryusuke Konishi
