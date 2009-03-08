From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Dump tools for checkpoints
Date: Sun, 08 Mar 2009 14:39:16 +0900 (JST)
Message-ID: <20090308.143916.113539820.ryusuke@osrg.net>
References: <2883.84.133.202.72.1235869032.squirrel@ssl.its-beck.de>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <2883.84.133.202.72.1235869032.squirrel-lZV7jZi4TBeO2lRZCxuEEg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, nilfs-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org

Hi,
On Sun, 01 Mar 2009 01:57:18 +0100, nilfs-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org wrote:
> Hi,
> 
> a great feature would be a tool to dump all filesystem changes since a
> given checkpoint up to the newest available cp. The resulting file could
> be fed to another filesystem for replication.
> 
> For a start, two tools: One to create and one to execute a binary dump.
> 
> Other projects can develop on top of these. A networked client / server to
> keep a remote site in sync in master / slave style, for example. But some
> self-made scripts could pipe the dump files between systems as well.
> 
> This would be much faster, compared to rsync and similar tools which need
> to scan the source system.
> 
> Greetings,
> 
> Pierre Beck

Sorry for my late reply.

I've moved the replication feature to the top of todo list in our web
site ;)

Actually I want to realize this feature in some form, and had
considered details several times.  What I want to realize is
checkpoint based replication including incremental dumping and
restoration of file system states.

Basically I believe this is possible, but one problem is how to
realize rollback of the remote nilfs which will become required when
allowing user's updates or garbage collection on the remote device
after synchronization.

Some of meta data files of nilfs (e.g. checkpoint file, segment usage
file, disk address translation file) do not keep past versions even
though they are written in a copy-on-write manner.  And it would be
too complex to roll back these files.  At present, I am seeking the
way not requiring big change of disk format, but some state
conflictions (concretely speaking, confliction of virtual block numers
maintained in the DAT file) must be resolved under the condition.  A
breakthrough is needed for this.

Anyway, I'm expecting we can find out a realistic solution for those
technical things at some stage.

Regards,
Ryusuke Konishi
