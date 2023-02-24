  htmp = zero
  !
  !> H_Imp: Diagonal Elements, i.e. local part
  do io=1,Ns
     htmp = htmp + Hdiag(1,io)*Nup(io) + Hdiag(Nspin,io)*Ndw(io)
  enddo
  !
  !> H_Int: Kanamori interaction part. 
  ! = \sum_\a U_\a*(n_{\a,up}*n_{\a,dw})
  if(any(Uloc/=0d0))then
     do iorb=1,Norb
        do isite=1,Nsites(iorb)
           io = pack_indices(isite,iorb)
           htmp = htmp + Uloc(iorb)*Nele_up(io)*Nele_dw(io)
        enddo
     enddo
  endif
  !
  !density-density interaction: different orbitals, opposite spins:
  ! =  (Uprime=Uloc-2*Jh)*sum_{i/=j} [ n_{i,up}*n_{j,dw} + n_{j,up}*n_{i,dw} ]
  do iorb=1,Norb
     do jorb=iorb+1,Norb
        do isite=1,Nsites(iorb)
           do jsite=1,Nsites(jorb)
              if(isite/=jsite)cycle !local interaction only:
              io = pack_indices(isite,iorb)
              jo = pack_indices(isite,jorb)
              htmp = htmp + Ust*(Nele_up(io)*Nele_dw(jo) + Nele_up(jo)*Nele_dw(io))
           enddo
        enddo
     enddo
  enddo
  !
  !density-density interaction: different orbitals, parallel spins
  ! = \sum_{i<j} (Usecond==Uloc-3*Jh)*[ n_{i,up}*n_{j,up} + n_{i,dw}*n_{j,dw} ]
  do iorb=1,Norb
     do jorb=iorb+1,Norb
        do isite=1,Nsites(iorb)
           do jsite=1,Nsites(jorb)
              if(isite/=jsite)cycle !local interaction only:
              io = pack_indices(isite,iorb)
              jo = pack_indices(isite,jorb)
              htmp = htmp + (Ust-Jh)*(Nele_up(io)*Nele_up(jo) + Nele_dw(io)*Nele_dw(jo))
           enddo
        enddo
     enddo
  enddo
  !
  if(ed_filling==0)then
     do io=1,Ns
        htmp = htmp - xmu*( Nup(io)+Ndw(io) )
     enddo
     !
     if(hfmode)then
        if(any(Uloc/=0d0))then
           do iorb=1,Norb
              do isite=1,Nsites(iorb) 
                 io = pack_indices(isite,iorb)
                 htmp = htmp - 0.5d0*Uloc(iorb)*(Nele_up(io)+Nele_dw(io))
              enddo
           enddo
        endif
        if(Norb>1)then
           do iorb=1,Norb
              do jorb=iorb+1,Norb
                 do isite=1,Nsites(iorb)
                    do jsite=1,Nsites(jorb)
                       if(isite/=jsite)cycle !local interaction only:
                       io = pack_indices(isite,iorb)
                       jo = pack_indices(isite,jorb)
                       htmp=htmp - 0.5d0*Ust*(Nele_up(io)+Nele_dw(io)+Nele_up(jo)+Nele_dw(jo))
                       htmp=htmp - 0.5d0*(Ust-Jh)*(Nele_up(io)+Nele_dw(io)+Nele_up(jo)+Nele_dw(jo))
                    enddo
                 enddo
              enddo
           enddo
        endif
     endif
  endif
  !
  i = j
  hv(i-MpiIshift) = hv(i-MpiIshift) + htmp*vin(i)
