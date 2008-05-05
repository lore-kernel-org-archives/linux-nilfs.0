From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: some questions
Date: Tue, 06 May 2008 01:38:30 +0900 (JST)
Message-ID: <20080506.013830.14997213.ryusuke@osrg.net>
References: <481DE17B.3080407@prnet.org>
	<20080506.005511.117028003.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080506.005511.117028003.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
Content-Type: Text/Plain; charset="us-ascii"
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org

> > 3. How robust is nilfs to device errors like bad sectors ? For example 
> > if you have a disk image where bad sectors are replaced by zeros, will 
> > you still be able to recover data from other sectors ?
> 
> When NILFS detects an I/O error, it tries to mark the segment including
> the bad block erroneous. The errorneous segment will never be reused.

For the latter question, the current NILFS does not have this kind of data
integrity.

Of course there are various opinions or ideas in the team.
I think, I'd like to make use of HW support such as SCSI DIF if Linux bio
will support it.

Regards,
Ryusuke Konishi
