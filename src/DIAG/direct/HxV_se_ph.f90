  htmp = zero
  !
  ! SPIN-EXCHANGE (S-E) TERMS
  !    S-E: J Cdg_a.up Cdg_b.dw C_a.dw C_b.up
  if(jhflag.AND.Jx/=0d0)then
     do iorb=1,Norb
        do jorb=1,Norb
           do isite=1,Nsites(iorb)
              do jsite=1,Nsites(jorb)
                 if(isite/=jsite)cycle !local interaction only:
                 io = pack_indices(isite,iorb)
                 jo = pack_indices(isite,jorb)
                 Jcondition=(&
                      (io/=jo).AND.&
                      (Nele_Up(jo)==1).AND.&
                      (Nele_Dw(io)==1).AND.&
                      (Nele_Dw(jo)==0).AND.&
                      (Nele_Up(io)==0))
                 if(Jcondition)then
                    call c(jo,m,k1,sg1)
                    call c(io+eNs,k1,k2,sg2)
                    call cdg(jo+eNs,k2,k3,sg3)
                    call cdg(io,k3,k4,sg4)
                    i=binary_search(Hsector%H(1)%map,k4)
                    htmp = one*Jx*sg1*sg2*sg3*sg4
                    !
                    if(i/=0)hv(i-MpiIshift) = hv(i-MpiIshift) + htmp*vin(j)
                    !
                 endif
              enddo
           enddo
        enddo
     enddo
  endif
  !
  ! PAIR-HOPPING (P-H) TERMS
  !    P-H: J Cdg_a.up Cdg_a.dw   C_b.dw   C_b.up
  if(jhflag.AND.Jp/=0d0)then
     do iorb=1,Norb
        do jorb=1,Norb
           do isite=1,Nsites(iorb)
              do jsite=1,Nsites(jorb)
                 if(isite/=jsite)cycle !local interaction only:
                 io = pack_indices(isite,iorb)
                 jo = pack_indices(isite,jorb)
                 Jcondition=(&
                      (Nele_Up(jo)==1).AND.&
                      (Nele_Dw(jo)==1).AND.&
                      (Nele_Dw(io)==0).AND.&
                      (Nele_Up(io)==0))
                 if(Jcondition)then
                    call c(jo,m,k1,sg1)
                    call c(jo+eNs,k1,k2,sg2)
                    call cdg(io+eNs,k2,k3,sg3)
                    call cdg(io,k3,k4,sg4)
                    i=binary_search(Hsector%H(1)%map,k4)
                    htmp = one*Jp*sg1*sg2*sg3*sg4
                    !
                    if(i/=0)hv(i-MpiIshift) = hv(i-MpiIshift) + htmp*vin(j)
                    !
                 endif
              enddo
           enddo
        enddo
     enddo
  endif
