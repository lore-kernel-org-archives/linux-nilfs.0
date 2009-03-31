From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Constant checkpointing and cleanerd activity -
 doesn't play nice with mount --bind ?
Date: Wed, 01 Apr 2009 00:10:59 +0900 (JST)
Message-ID: <20090401.001059.06956465.ryusuke@osrg.net>
References: <20090317.224324.58871500.ryusuke@osrg.net>
	<20090317191924.1924576b@natsu.i4>
	<20090331.234437.112904649.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090331.234437.112904649.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: roman-ohbefDXYbNo@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On Tue, 31 Mar 2009 23:44:37 +0900 (JST), Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> Now, I'm considering not to invoke cleanerd for bind-mounts.  It is
> too complex to switch over the base directory of cleanerd along with
> mount/umount events as above.  (It is possible but I'd rather avoid
> complicating life management of cleanerd any further.)
> 
> In addition, the bind mount can attach only part of a single
> filesystem, and therefore the .nilfs file, which is required for
> proper cleaner operation, is not assured to exist on the top of mount
> point for bind mounts.
> 
> Do you have any inconvenience if I disable GC for bind mounts?
> 
> Usually bind mount has an original rw-mount though Linux can
> detach original mount prior to the bind-mount.

Let me add one thing.  Since the bind-mount and original r/w-mount
share the same device, only one cleanerd is enough for them.  (In
fact, two cleanerds conflict with one another).  So, we can give over
the GC functionality to the original mount point without incident.

Ryusuke
