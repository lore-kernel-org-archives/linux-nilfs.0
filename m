From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: samba hanging with 100% cpu load
Date: Fri, 19 Dec 2008 02:42:41 +0900 (JST)
Message-ID: <20081219.024241.30462112.ryusuke@osrg.net>
References: <41366.212.24.212.169.1229515379.squirrel@www.prnet.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <41366.212.24.212.169.1229515379.squirrel-YfwCgBv0H3oBXFe83j6qeQ@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org

Hi David,

On Wed, 17 Dec 2008 13:02:59 +0100 (CET), David Arendt wrote:
> Hi,
> 
> I am using samba to serve files from a nilfs2 filesystem. From time to
> time, I have smbd's hanging in state R with 100% cpu usage. Even kill
> -KILL won't kill them. If I do an smbstatus it show me open files on the
> nilfs2 filesystem which are not opened by any share. It started appearing
> when I started using nilfs2, so I think it could be nilfs2 related but I'm
> not sure. Did anyone experience similiar problems with nilfs2 and samba ?

Let me ask you a few questions:

First, please tell me your kernel version (and config if possible).
Are you using nilfs-2.0.5 and nilfs-utils-2.0.6 packages?

How many snapshots (not checkpoints) did you create in the volume?

Does the cleaner (i.e. nilfs_cleanerd) affect on the problem?
If you mount the volume with -i option, the cleanerd will not be
invoked:

 e.g.
 # mount -t nilfs2 -i /dev/xxx /mount-dir

This is convenient to separate cleaner problems.

We are also using samba and nilfs in our storage server, so we have
interest in the problem though we haven't yet experienced this
phenomenon.


With regards,
Ryusuke
